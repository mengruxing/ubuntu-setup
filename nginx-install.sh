#!/bin/bash
#
# Author: Mr.x
#
# Copyright (c) http://mrxing.org
#
PATH='/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin'
cd `dirname $0`
EXEC_PATH=`pwd`

sudo tee /etc/apt/sources.list.d/nginx-trusty.list << EOF
deb http://nginx.org/packages/ubuntu/ trusty nginx
deb-src http://nginx.org/packages/ubuntu/ trusty nginx
EOF
wget -O- http://nginx.org/keys/nginx_signing.key | sudo apt-key add -
sudo apt-get update

sudo apt-get install nginx
sudo tar -zxvf ${EXEC_PATH}/software/nginx-rtmp-module-1.1.11.tar.gz -C ${EXEC_PATH}/tmp/
cd ${EXEC_PATH}/tmp/nginx/
apt-get source nginx
sudo apt-get build-dep nginx
cd nginx-1.12.0/
# TUDO: 更改正则
sed -i '' debian/rules
dpkg-buildpackage
cd .. && sudo dpkg -i nginx*.deb
sudo mkdir /usr/local/shell
sudo cp ${EXEC_PATH}/nginx/nginx-rtmp-hls.sh /usr/local/shell/
sudo mkdir /etc/nginx/rtmp.conf.d
sudo cp ${EXEC_PATH}/nginx/default.conf /etc/nginx/rtmp.conf.d/
sudo tee -a /etc/nginx/nginx.conf << EOF

rtmp {
    include /etc/nginx/rtmp.conf.d/*.conf;
}

EOF
sudo service nginx restart
