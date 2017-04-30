#!/usr/bin/env bash
git add --all
read -p "Commit message： " i
git commit -m "$i"
