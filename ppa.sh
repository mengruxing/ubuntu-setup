#!/bin/bash
#
# Author: Mr.x
#
# Copyright (c) http://mrxing.org
#
PATH='/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin'

sudo add-apt-repository ppa:wiznote-team -y  # wiznote
sudo add-apt-repository ppa:tualatrix/ppa -y  # ubuntu-tweak
sudo add-apt-repository ppa:noobslab/themes -y  # themes e.g. flatabulous-theme
sudo add-apt-repository ppa:noobslab/icons -y  # icons e.g. ultra-flat-icons
sudo add-apt-repository ppa:noobslab/apps -y  # apps e.g. indicator-synapse
sudo add-apt-repository ppa:noobslab/indicators -y # indicators e.g.
sudo add-apt-repository ppa:fossfreedom/indicator-sysmonitor -y  # indicator-sysmonitor
sudo add-apt-repository ppa:fixnix/netspeed -y  # indicator-netspeed-unity
sudo add-apt-repository ppa:yktooo/ppa -y  # indicator-sound-switcher
sudo add-apt-repository ppa:synapse-core/ppa -y  # synapse
#sudo add-apt-repository ppa:nginx/stable -y  # nginx
sudo add-apt-repository ppa:webupd8team/java -y  # java
sudo add-apt-repository ppa:webupd8team/sublime-text-3  # sublime text 3
sudo add-apt-repository ppa:webupd8team/atom -y # atom
sudo add-apt-repository ppa:webupd8team/unstable -y # guake
#sudo add-apt-repository ppa:webupd8team/terminix -y # terminix
sudo add-apt-repository ppa:docky-core/ppa -y  # docky
sudo add-apt-repository ppa:numix/ppa -y  # numix theme icon
sudo add-apt-repository ppa:hzwhuang/ss-qt5 -y  # shadowsocks
sudo add-apt-repository ppa:djcj/screenfetch -y  # screenfetch
sudo add-apt-repository ppa:mc3man/trusty-media -y  # ffmpeg
sudo add-apt-repository ppa:mvo/gir-multiarch -y # libappindicator   修复网易云音乐托盘问题
#sudo add-apt-repository ppa:notepadqq-team/notepadqq -y # notepadqq

sudo sed -i 's/^.*#.*deb-src/deb-src/g' /etc/apt/sources.list.d/*
sudo apt-get update
