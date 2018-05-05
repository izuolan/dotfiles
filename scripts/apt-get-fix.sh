#!/usr/bin/env bash
sudo apt-get clean
cd /var/lib/apt
sudo rm -rf lists
echo =========================
echo Success delete old lists.
echo =========================
sudo mkdir -p lists/partial
sudo apt-get clean && sudo apt-get update
