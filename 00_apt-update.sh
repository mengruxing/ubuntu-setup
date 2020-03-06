#!/usr/bin/env bash

cd `dirname $0`

mkdir -p ~/backup/dpkg
if [ ! -f ~/backup/dpkg/dpkg.list.txt ]; then
  dpkg --get-selections | cut -f 1 > ~/backup/dpkg/dpkg.list.txt
fi
sudo sed -i 's/^\s*#\s*\(deb.*https\?\)/\1/g;s/\(https\?:\/\/\)\(archive\.ubuntu\.com\)/\1cn\.\2/g' /etc/apt/sources.list
sudo apt-get update && sudo apt-get dist-upgrade -y && echo 'operation completed! system needs to reboot..'
