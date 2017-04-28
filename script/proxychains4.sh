#! /bin/bash
CONFIG_PATH="/home/zuolan/Sync/Shell/config"
DEFAULT="g1"
ORIGIN_COMMAND=$(echo "$@" | sed "s/$1 //g" | sed "s/$2 //g")

config_file(){
    CONFIG_FILE=$OPTARG
    PROXY_COMMAND="proxychains4 -f $CONFIG_PATH/$CONFIG_FILE.conf -q"
    COMMAND="$PROXY_COMMAND $ORIGIN_COMMAND"
    bash -c "$COMMAND"
}
default(){
    PROXY_COMMAND="proxychains4 -f $CONFIG_PATH/$DEFAULT.conf -q";
    COMMAND="$PROXY_COMMAND $ORIGIN_COMMAND"
    bash -c "$COMMAND"
}

while getopts ":f:h" optname
  do
    case "$optname" in
      "f") config_file ;;
      "h") echo "使用 -f <config> 选项指定配置文件。"; exit 0 ;;
      "?") echo -n "错误参数："; $0 -h; exit 1 ;;
      *) echo -n "未知错误："; $0 -h; exit 1 ;;
    esac
  done

if [ "$1" != "-f" ]; then
    ORIGIN_COMMAND=$(echo "$@");
    default;
fi
