#!/usr/bin/env bash

cd `dirname $0`

sudo apt-get install -y dkms lib32gcc-5-dev

sudo init 3

sudo tee /etc/modprobe.d/blacklist-nouveau.conf << EOF
blacklist nouveau
options nouveau modeset=0
EOF
sudo update-initramfs -u
