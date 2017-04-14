#!/bin/bash
#
# Author: Mr.x
#
# Copyright (c) http://mrxing.org
#
PATH='/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin'
sudo tee /etc/modprobe.d/blacklist-nouveau.conf << EOF
blacklist nouveau
options nouveau modeset=0
EOF
sudo update-initramfs -u
echo '更新内核模块需要重启系统，是否现在重启？'
read -p '(y)es/(n)o/(q)uit: ' opt
if [ 'yes' = $opt ] || [ 'y' = $opt ] || [ '' = $opt ]; then
  sudo reboot
fi
