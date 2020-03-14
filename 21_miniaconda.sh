#!/usr/bin/env bash

cd `dirname $0`

./request-file.sh Miniconda2-4.7.12.1-Linux-x86_64.sh

chmod +x ./local/Miniconda2-4.7.12.1-Linux-x86_64.sh

sudo ./local/Miniconda2-4.7.12.1-Linux-x86_64.sh -b -p /opt/miniconda2
cd /opt && sudo ln -sf miniconda2 miniconda
if [ ! -d /etc/profile.d/opt ]; then
  sudo mkdir /etc/profile.d/opt
fi
sudo tee /etc/profile.d/opt/miniconda.sh << EOF
export PATH=\$PATH:/opt/miniconda/bin
EOF
