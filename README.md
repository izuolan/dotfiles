# dotfiles
Awesome dotfiles and system init sctipt. Just one command to install:

```
curl -sSL https://git.io/Dotfiles | bash
```

#### Tmux
Base on [gpakosz](https://github.com/gpakosz/.tmux) configuration):

![Tmux](https://cloud.githubusercontent.com/assets/553208/19740585/85596a5a-9bbf-11e6-8aa1-7c8d9829c008.gif)

#### Vim
Base on [EverVim](https://github.com/LER0ever/EverVim):

![EverVim](https://camo.githubusercontent.com/8b29024891565c1f8af68b528dd3355744b1d2dc/687474703a2f2f692e696d6775722e636f6d2f733867613243762e706e67)

#### Zsh

Base on [Oh-My-Zsh](http://ohmyz.sh/).

# Get Start
#### Firstly, Install dotfile
```
curl -sSL https://git.io/Dotfiles | bash
```
#### Secondly, set RPC password
If all is well, you should set Aria2 RPC password:
```
bash ~/.dotfiles/install.sh -p <aria2_rpc_password>
```
#### Thirdly, install patched fonts
And on your **local** terminal, maybe you need install patched fonts:
```
sudo apt install powerline
```
And download [nerd-fonts](https://github.com/ryanoasis/nerd-fonts/):
```
wget https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/Hack/Regular/complete/Knack%20Regular%20Nerd%20Font%20Complete%20Mono.ttf
```

# For China:
Firstly, clone this repo to $HOME/.dotfiles, and then set socks5 proxy (Shadowsocks):
```
bash ~/.dotfiles/install.cn.sh -s
```
Finaly:
```
curl -sSL https://git.io/Dotfiles_CN | bash
```
All is well, you should install patched fonts.