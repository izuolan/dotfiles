#!/usr/bin/env bash
git add --all
read -p "输入更新信息： " i
git commit -m "$i"
