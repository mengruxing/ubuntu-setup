#!/usr/bin/env bash

cd `dirname $0`

./request-file.sh Miniconda2-4.7.12.1-Linux-x86_64.sh

chmod +x ./local/Miniconda2-4.7.12.1-Linux-x86_64.sh

sudo ./local/Miniconda2-4.7.12.1-Linux-x86_64.sh -b -p /opt/miniconda2
cd /opt && sudo ln -sf miniconda2 miniconda && sudo ln -s miniconda conda
sudo tee /etc/profile.d/opt-conda.sh << EOF
export PATH=\$PATH:/opt/conda/bin
EOF
if [ -e /etc/profile.d/opt-anaconda.sh ]; then
  sudo rm /etc/profile.d/opt-anaconda.sh
fi
