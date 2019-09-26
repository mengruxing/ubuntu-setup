#!/usr/bin/env bash

cd `dirname $0`

sudo ./files/Anaconda2-2018.12-Linux-x86_64.sh -b -f /opt/anaconda2
cd /opt && sudo ln -sf anaconda2 anaconda
cd -
if [ ! -d /etc/profile.d/opt ]; then
  sudo mkdir /etc/profile.d/opt
fi
sudo tee /etc/profile.d/opt/anaconda.sh << EOF
export PATH=\$PATH:/opt/anaconda/bin
EOF
