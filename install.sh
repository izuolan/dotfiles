#!/bin/bash
software(){
    apt update && apt -y dist-upgrade
    apt install -y curl wget git zsh vim aria2 make
    apt-get autoremove -y
    # vim-gnome
}

zsh(){
    sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
    ln -sf ~/.dotfiles/config/zshrc .zshrc
}

vim(){
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/LER0ever/EverVim/master/Boot-EverVim.sh)"
    apt-get install build-essential cmake
    apt-get install python-dev python3-dev
    cd ~/.vim/bundle/YouCompleteMe
    ./install.py --clang-completer
    ./install.py
    echo "Use vim command ':PlugInstall' install plugins."
}

tmux(){
    # Install Tmux from source
    TMUX_VERSION=2.4
    apt install -y libncurses5-dev libevent-dev
    eval wget https://github.com/tmux/tmux/releases/download/${TMUX_VERSION}/tmux-${TMUX_VERSION}.tar.gz -O /tmp/tmux-${TMUX_VERSION}.tar.gz
    cd /tmp && eval tar xf /tmp/tmux-${TMUX_VERSION}.tar.gz
    eval cd /tmp/tmux-${TMUX_VERSION} && ./configure && make
    make install
    rm -rf /tmp/tmux-*
    # Tmux Powerline
    cd ~/ && git clone https://github.com/erikw/tmux-powerline.git ~/.tmux-powerline
    # Copy Tmux Configuration
    cd ~/ && rm -rf ~/.tmux
    git clone https://github.com/izuolan/.tmux.git ~/.dotfiles/tmux
    ln -sf ~/.dotfiles/tmux/powerline/mytheme.sh ~/.tmux-powerline/themes/mytheme.sh
    ln -sf ~/.dotfiles/tmux/powerline/tmux-powerlinerc ~/.tmux-powerlinerc
    ln -sf ~/.dotfiles/tmux ~/.tmux
    ln -sf ~/.dotfiles/tmux/tmux.conf ~/.tmux.conf
    # Init Plugins
    mkdir -p ~/.dotfiles/tmux/plugins
    git clone https://github.com/tmux-plugins/tpm.git ~/.dotfiles/tmux/plugins/tpm
    git clone https://github.com/tmux-plugins/tmux-sensible.git ~/.dotfiles/tmux/plugins/tmux-sensible
    git clone https://github.com/tmux-plugins/tmux-copycat.git ~/.dotfiles/tmux/plugins/tmux-copycat
    git clone https://github.com/tmux-plugins/tmux-yank.git ~/.dotfiles/tmux/plugins/tmux-yank
    git clone https://github.com/tmux-plugins/tmux-urlview.git ~/.dotfiles/tmux/plugins/tmux-urlview
}

env(){
    git clone https://github.com/izuolan/env.git
}

docker(){
    command -v docker >/dev/null 2>&1
	if [ $? != 0 ]; then curl -sSL https://get.docker.com/ | sh; fi
}

proxychains4(){
    command -v proxychains4 >/dev/null 2>&1
    if [ $? != 0 ]; then 
        git clone https://git.oschina.net/zuolan/proxychains-ng.git /tmp/proxychains-ng
        cd /tmp/proxychains-ng
        ./configure –prefix=/usr –sysconfdir=/etc
        make && make install && make install-config
        rm -rf /tmp/proxychains-ng
        echo "Proxychains4 Installed."
    fi
}

aria2(){
    echo -n "Please enter the Aria2 remote password (can be downloaded remote monitoring progress):"; read -s PASS;echo ""
    sed -i "s:ARIA2_PASSWORD:$PASS:g" ~/.dotfiles/config/aria2.conf
    echo "successfully."
}

while getopts ":p:h" optname
  do
    case "$optname" in
      "p") aria2 ;;
      "h") echo "Use -p <aria2_rpc_password> option set RPC password."; exit 0 ;;
      "?") echo -n "Unknown option:"; $0 -h; exit 1 ;;
      *) echo -n "Unknown error:"; $0 -h; exit 1 ;;
    esac
  done

if [ ! -f ~/.dotfiles ]; then 
    git clone https://github.com/izuolan/dotfiles.git ~/.dotfiles
else
    echo ".dotfiles already exists, so just update this script."
    cd ~/.dotfiles && git pull
fi
chmod a+x ~/.dotfiles/script/*
software
docker
proxychains4
zsh
source .zshrc
tmux
vim
