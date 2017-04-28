#!/bin/bash
while [ -n "$1" ]
do
  case "$1" in
    -s|--set)
        echo $1 $2
        sed -i "s|#export http_proxy|export http_proxy|g" ~/.zshrc
        sed -i "s|#export https_proxy|export https_proxy|g" ~/.zshrc
        exit 0
        ;;
    -u|--unset)
        cat ~/.zshrc | grep "#export http_proxy"
        if [ $? = 0 ]; then
            echo "已经取消终端代理。"
        else
            sed -i "s|export http_proxy|#export http_proxy|g" ~/.zshrc
            sed -i "s|export https_proxy|#export https_proxy|g" ~/.zshrc
        fi
        exit 0
        ;;
    -h|--help)
        echo "Use -s option set proxy, and use -u unset proxy."
        exit 0
        ;;
    *)
        echo "$1 is not an option"
        exit 1
        ;;
  esac
  shift
done