#!/bin/bash

software(){
    apt update && apt -y dist-upgrade
    apt install -y curl wget git zsh vim aria2 make
    # vim-gnome
}

hosts(){
    wget https://coding.net/u/scaffrey/p/hosts/git/raw/master/hosts -O fetchedhosts
    mv /etc/hosts /etc/hosts-$(date +%F-%H%M%S).bak
    sed -i "s/localhost/localhost $(hostname)/g" fetchedhosts
    sed -i "s/broadcasthost/broadcasthost $(hostname)/g" fetchedhosts
    mv fetchedhosts /etc/hosts
    echo Hosts更新完成！！
}

proxychains4(){
    command -v proxychains4 >/dev/null 2>&1
    if [ $? != 0 ]; then 
        git clone https://git.oschina.net/zuolan/proxychains-ng.git /tmp/proxychains-ng
        cd /tmp/proxychains-ng
        ./configure –prefix=/usr –sysconfdir=/etc
        make && make install && make install-config
        rm -rf /tmp/proxychains-ng
        echo "Proxychains4 安装成功。"
    fi
}

docker(){
    command -v docker >/dev/null 2>&1
	if [ $? != 0 ]; then curl -sSL https://get.docker.com/ | sh; fi
    echo "{"registry-mirrors": ["https://docker.mirrors.ustc.edu.cn"]}" > /etc/docker/daemon.json
}

ss_start(){
    docker rm -f ss
    docker run -dit --name=ss \
        -p 127.0.0.1:1080:1080 \
        --restart=always \
        -v ~/.dotfiles/config/sslocal.json:/etc/sslocal.json:ro \
        easypi/shadowsocks-libev ss-local -c /etc/sslocal.json
}

ss_stop(){
    docker rm -f ss
}

zsh(){
    proxychains4 -q -f $HOME/.dotfiles/config/proxychains4.conf \
        wget https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O /tmp/install.sh
    proxychains4 -q -f $HOME/.dotfiles/config/proxychains4.conf \
        bash /tmp/install.sh
    rm /tmp/install.sh
    ln -sf $HOME/.dotfiles/config/zshrc .zshrc
}

vim(){
    proxychains4 -q -f $HOME/.dotfiles/config/proxychains4.conf \
        wget https://raw.githubusercontent.com/LER0ever/EverVim/master/Boot-EverVim.sh -O /tmp/Boot-EverVim.sh
    proxychains4 -q -f $HOME/.dotfiles/config/proxychains4.conf \
        bash /tmp/Boot-EverVim.sh
    rm /tmp/Boot-EverVim.sh
    # All done with this script, now run vim/neovim and execute ":PlugInstall"
}

lang(){
    dpkg-reconfigure locales
}

tmux(){
    # Install Tmux from source
    TMUX_VERSION=2.4
    apt install -y libncurses5-dev libevent-dev
    wget https://github.com/tmux/tmux/releases/download/${TMUX_VERSION}/tmux-${TMUX_VERSION}.tar.gz -O /tmp/tmux-${TMUX_VERSION}.tar.gz
    tar xf tmux-${TMUX_VERSION}.tar.gz
    cd /tmp/tmux-${TMUX_VERSION} && ./configure && make
    make install
    rm -rf /tmp/tmux-*
    # Tmux Powerline
    git clone https://github.com/erikw/tmux-powerline.git ~/.tmux-powerline
    # Copy Tmux Configuration
    cd ~/ && rm -rf ~/.tmux
    git clone https://github.com/izuolan/.tmux.git ~/.dotfiles/tmux
    ln -sf ~/.dotfiles/tmux/powerline/mytheme.sh ~/.tmux-powerline/themes/mytheme.sh
    ln -sf ~/.dotfiles/tmux/powerline/tmux-powerlinerc ~/.tmux-powerlinerc
    ln -sf ~/.dotfiles/tmux ~/.tmux
    ln -sf ~/.dotfiles/tmux.conf ~/.tmux.conf
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

aria2_config(){
    echo -n "Please enter the Aria2 remote password (can be downloaded remote monitoring progress):"; read -s PASS;echo ""
    sed -i "s:ARIA2_PASSWORD:$2:g" $HOME/.dotfiles/config/aria2.conf
    echo "successfully."
}
ss_config(){
    echo "现在配置 Shadowsocks 代理。"
    echo -n "请输入 Shadowsocks 账号的 IP:"; read SS_SERVER_IP;echo ""
    sed -i "s|"server": ""|"server": "$SS_SERVER_IP"|g" $HOME/.dotfiles/config/sslocal.json
    echo -n "请输入 Shadowsocks 账号的端口:"; read SS_SERVER_PORT;echo ""
    sed -i "s|"server_port": ""|"server_port": "$SS_SERVER_PORT"|g" $HOME/.dotfiles/config/sslocal.json
    echo -n "请输入 Shadowsocks 账号的密码（输入不可见）:"; read -s SS_SERVER_PASSWORD;echo ""
    sed -i "s|"password": ""|"password": "$SS_SERVER_PASSWORD"|g" $HOME/.dotfiles/config/sslocal.json
    echo "其他情况请自行编辑 $HOME/.dotfiles/config/sslocal.json 这个文件以配置代理。"
}
while getopts ":p:sh" optname
  do
    case "$optname" in
      "p") aria2_config ;;
      "s") ss_config ;;
      "h") echo "使用 -p <aria2_rpc_password> 参数设置 RPC 密码，使用 -s 设置代理。"; exit 0 ;;
      "?") echo -n "Unknown option:"; $0 -h; exit 1 ;;
      *) echo -n "Unknown error:"; $0 -h; exit 1 ;;
    esac
  done

if [ ! -f $HOME/.dotfiles ]; then 
    git clone https://github.com/izuolan/dotfiles.git $HOME/.dotfiles
else
    echo ".dotfiles 已经存在，更新脚本。"
    cd $HOME/.dotfiles && git pull
fi
chmod a+x $HOME/.dotfiles/script/*
software
hosts
proxychains4
docker
ss_start
zsh
source .zshrc
tmux
lang
vim
