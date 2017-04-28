#!/bin/bash
software(){
    sudo apt update && sudo apt -y dist-upgrade
    sudo apt install -y curl wget git zsh vim tmux aria2 make
    # vim-gnome
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

help(){
    echo "./install.sh <hostname> <aria2_rpc_password>"
}

if [ ! -f ~/.dotfiles ]; then 
    git clone https://github.com/izuolan/dotfiles.git ~/.dotfiles
else
    echo ".dotfiles already exists, so just update this script."
    cd ~/.dotfiles && git pull
fi
hostname $1
sed -i "s:ARIA2_PASSWORD:$2:g" ~/.dotfiles/config/aria2.conf
chmod a+x ~/.dotfiles/script/*
software
docker
proxychains4
zsh
source .zshrc
tmux
vim