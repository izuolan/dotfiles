#!/bin/bash
PROXY="proxychains4 -q -f ~/.dotfiles/config/proxychains4.conf"

software(){
    sudo apt update && sudo apt -y dist-upgrade
    sudo apt install -y curl wget git zsh vim tmux aria2 make shadowsocks
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

proxychains4(){
    VERSION=4.12
    wget https://github.com/rofl0r/proxychains-ng/releases/download/v${VERSION}/proxychains-ng-${VERSION}.tar.xz -O /tmp/proxychains-ng-${VERSION}.tar.xz
    cd /tmp && tar xf /tmp/proxychains-ng-${VERSION}.tar.xz && cd proxychains-ng-${VERSION}
	sudo ./configure –prefix=/usr –sysconfdir=/etc
	sudo make && sudo make install && sudo make install-config
    rm -rf /tmp/proxychains-ng-${VERSION}
}

ss_start(){
    nohup sslocal -c ~/.dotfiles/config/sslocal.json &
}

docker(){
    curl -sSL https://get.docker.com/ | sh
    echo "{"registry-mirrors": ["https://docker.mirrors.ustc.edu.cn"]}" > /etc/docker/daemon.json
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
echo -n "请输入 Aria2 远程密码（可以远程监控下载进度）:"; read -s PASS;echo ""
sed -i "s:ARIA2_PASSWORD:$PASS:g" ~/.dotfiles/config/aria2.conf
echo "密码设置成功。"
chmod a+x ~/.dotfiles/script/*
echo "现在配置 Shadowsocks 代理。"
echo -n "请输入 Shadowsocks 账号的 IP:"; read SS_SERVER_IP;echo ""
sed -i "s|"server": ""|"server": "$SS_SERVER_IP"|g" ~/.dotfiles/config/sslocal.json
echo -n "请输入 Shadowsocks 账号的端口:"; read SS_SERVER_PORT;echo ""
sed -i "s|"server_port": ""|"server_port": "$SS_SERVER_PORT"|g" ~/.dotfiles/config/sslocal.json
echo -n "请输入 Shadowsocks 账号的密码（输入不可见）:"; read -s SS_SERVER_PASSWORD;echo ""
sed -i "s|"password": ""|"password": "$SS_SERVER_PASSWORD"|g" ~/.dotfiles/config/sslocal.json
echo "其他情况请自行编辑 ~/.dotfiles/config/sslocal.json 这个文件以配置代理。"
software
hosts
proxychains4
ss_start
docker
zsh
source .zshrc
tmux
vim