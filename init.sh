#!/bin/bash
software(){
    sudo apt update && sudo dist-upgrade
    sudo apt install -y curl git zsh vim tmux aria2
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

zsh(){
    sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
    ln -sf ~/.dotfiles/config/zshrc .zshrc
}

vim(){
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/LER0ever/EverVim/master/Boot-EverVim.sh)"
}

tmux(){
    cd ~/ && rm -rf ~/.tmux
    git clone https://github.com/gpakosz/.tmux.git
    ln -sf .tmux/.tmux.conf
    cp .tmux/.tmux.conf.local .
}

docker(){
    curl -sSL https://get.docker.com/ | sh
    echo "{"registry-mirrors": ["https://docker.mirrors.ustc.edu.cn"]}" > /etc/docker/daemon.json
}

proxychains4(){
    git clone https://github.com/rofl0r/proxychains-ng.git /tmp/proxychains-ng/
	cd /tmp/proxychains-ng/
	sudo ./configure –prefix=/usr –sysconfdir=/etc
	sudo make && sudo make install && sudo make install-config
}

snapper(){
    sudo snapper -c root create-config /
}

main(){
    rm -rf ~/.dotfiles
    git clone https://github.com/izuolan/dotfiles.git ~/.dotfiles
    hostname $1
    sed -i "s:ARIA2_PASSWORD:$2:g" ~/.dotfiles/config/aria2.conf
    software
    hosts
    zsh
    source .zshrc
    tmux
    docker
    proxychains4
    snapper
    vim
}

help(){
    echo "./init.sh <hostname> <aria2_rpc_password>"
}