#!/usr/bin/env bash

cd `dirname $0`

sudo service lightdm stop
sudo apt-get install -y nvidia-prime nvidia-settings nvidia-384 && echo 'operation completed! system needs to reboot..'
