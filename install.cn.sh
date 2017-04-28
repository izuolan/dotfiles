#!/bin/bash
PROXY="proxychains4 -q -f ~/.dotfiles/config/proxychains4.conf"

software(){
    sudo apt update && sudo apt -y dist-upgrade
    sudo apt install -y curl wget git zsh vim tmux aria2 make
    # vim-gnome
}

hosts(){
    wget https://raw.githubusercontent.com/racaljk/hosts/master/hosts -O fetchedhosts
    mv /etc/hosts /etc/hosts-$(date +%F-%H%M%S).bak
    sed -i "s/localhost/localhost $(hostname)/g" fetchedhosts
    sed -i "s/broadcasthost/broadcasthost $(hostname)/g" fetchedhosts
    mv fetchedhosts /etc/hosts
    echo Hosts更新完成！！
}

docker(){
    curl -sSL https://get.docker.com/ | sh
    echo "{"registry-mirrors": ["https://docker.mirrors.ustc.edu.cn"]}" > /etc/docker/daemon.json
}

ss_start(){
    docker pull easypi/shadowsocks-libev
    docker run -dit --name=ss-hk \
        -p 1080:1080 \
        --restart=always \
        easypi/shadowsocks-libev \
        ss-local \
            -s $SS_SERVER_IP \
            -p $SS_SERVER_PORT \
            -m aes-256-cfb \
            -k $SS_SERVER_PASSWORD \
            -b 0.0.0.0 \
            -l 1080 \
            -t 60 \
            --fast-open
}

proxychains4(){
    VERSION=4.12
    wget https://github.com/rofl0r/proxychains-ng/releases/download/v${VERSION}/proxychains-ng-${VERSION}.tar.xz -O /tmp/proxychains-ng-${VERSION}.tar.xz
    cd /tmp && tar xf /tmp/proxychains-ng-${VERSION}.tar.xz && cd proxychains-ng-${VERSION}
	sudo ./configure –prefix=/usr –sysconfdir=/etc
	sudo make && sudo make install && sudo make install-config
    rm -rf /tmp/proxychains-ng-${VERSION}
}

zsh(){
    $PROXY wget https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O /tmp/install.sh
    $PROXY bash /tmp/install.sh
    rm /tmp/install.sh
    ln -sf ~/.dotfiles/config/zshrc .zshrc
}

vim(){
    $PROXY wget https://raw.githubusercontent.com/LER0ever/EverVim/master/Boot-EverVim.sh -O /tmp/Boot-EverVim.sh
    $PROXY bash Boot-EverVim.sh
    rm /tmp/Boot-EverVim.sh
}

tmux(){
    cd ~/ && rm -rf ~/.tmux
    $PROXY git clone https://github.com/gpakosz/.tmux.git
    ln -sf .tmux/.tmux.conf
    cp .tmux/.tmux.conf.local .
}

help(){
    echo "./install.sh <hostname> <aria2_rpc_password>"
}

if [ ! -f ~/.dotfiles ]; then 
    git clone https://github.com/izuolan/dotfiles.git ~/.dotfiles
else
    echo ".dotfiles 已经存在，更新脚本。"
    cd ~/.dotfiles && git pull
fi

hostname $1
sed -i "s:ARIA2_PASSWORD:$2:g" ~/.dotfiles/config/aria2.conf
chmod a+x ~/.dotfiles/script/*
software
hosts
docker
ss_start
proxychains4
zsh
source .zshrc
tmux
vim