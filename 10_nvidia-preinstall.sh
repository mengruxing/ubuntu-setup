#!/usr/bin/env bash

cd `dirname $0`

sudo apt-get install -y bbswitch-dkms lib32gcc-5-dev

sudo service lightdm stop

sudo tee /etc/modprobe.d/blacklist-nouveau.conf << EOF
blacklist nouveau
options nouveau modeset=0
EOF
sudo update-initramfs -u
