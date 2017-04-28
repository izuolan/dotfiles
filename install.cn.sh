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
    git clone https://git.oschina.net/zuolan/proxychains-ng.git /tmp/proxychains-ng
	cd /tmp/proxychains-ng
    sudo ./configure –prefix=/usr –sysconfdir=/etc
	sudo make && sudo make install && sudo make install-config
    rm -rf /tmp/proxychains-ng
}

ss_start(){
    nohup sslocal -c ~/.dotfiles/config/sslocal.json >/dev/null 2>&1
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

aria2_config(){
    echo -n "Please enter the Aria2 remote password (can be downloaded remote monitoring progress):"; read -s PASS;echo ""
    sed -i "s:ARIA2_PASSWORD:$2:g" ~/.dotfiles/config/aria2.conf
    echo "successfully."
}
ss_config(){
    echo "现在配置 Shadowsocks 代理。"
    echo -n "请输入 Shadowsocks 账号的 IP:"; read SS_SERVER_IP;echo ""
    sed -i "s|"server": ""|"server": "$SS_SERVER_IP"|g" ~/.dotfiles/config/sslocal.json
    echo -n "请输入 Shadowsocks 账号的端口:"; read SS_SERVER_PORT;echo ""
    sed -i "s|"server_port": ""|"server_port": "$SS_SERVER_PORT"|g" ~/.dotfiles/config/sslocal.json
    echo -n "请输入 Shadowsocks 账号的密码（输入不可见）:"; read -s SS_SERVER_PASSWORD;echo ""
    sed -i "s|"password": ""|"password": "$SS_SERVER_PASSWORD"|g" ~/.dotfiles/config/sslocal.json
    echo "其他情况请自行编辑 ~/.dotfiles/config/sslocal.json 这个文件以配置代理。"
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

if [ ! -f ~/.dotfiles ]; then 
    git clone https://github.com/izuolan/dotfiles.git ~/.dotfiles
else
    echo ".dotfiles 已经存在，更新脚本。"
    cd ~/.dotfiles && git pull
fi
chmod a+x ~/.dotfiles/script/*
software
hosts
proxychains4
ss_start
docker
zsh
source .zshrc
tmux
vim