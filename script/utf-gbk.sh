#!/bin/bash
to_gbk(){
    find $2 -type d -exec mkdir -p /tmp/gbk/{} \;
    find $2 -type f -exec iconv -f UTF-8 -t GBK {} -o /tmp/gbk/{} \;
    echo "转码完成，转码之后的文件保存在/tmp/bgk中。"
}

to_utf(){
    find $2 -type d -exec mkdir -p /tmp/utf/{} \;
    find $2 -type f -exec iconv -f GBK -t UTF-8 {} -o /tmp/utf/{} \;
    echo "转码完成，转码之后的文件保存在/tmp/utf中。"
}
while getopts ":p:ugh" optname
  do
    case "$optname" in
      "p") echo "转换目录是：$2" ;;
      "u") to_utf; exit 0 ;;
      "g") to_gbk; exit 0 ;;
      "h") echo "$0 -p -u/-b"; exit 0 ;;
      "?") echo -n "错误参数，使用方法："; $0 -h; exit 1 ;;
      *) echo -n "未知错误，使用方法："; $0 -h; exit 1 ;;
    esac
  done