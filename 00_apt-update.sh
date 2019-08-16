#!/usr/bin/env bash

cd `dirname $0`

dpkg --get-selections | cut -f 1 > ~/dpkg.list.txt
sudo sed -i 's/\s*#\s*\(deb.*https\?\)/\1/g' /etc/apt/sources.list
sudo apt-get update && sudo apt-get dist-upgrade -y && echo 'operation completed! system needs to reboot..'
