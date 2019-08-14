#!/usr/bin/env bash

cd `dirname $0`

sudo service lightdm stop
sudo apt install -y nvidia-prime nvidia-settings nvidia-384 && nvidia-smi
sleep 3 && reboot
