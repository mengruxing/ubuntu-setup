#!/usr/bin/env bash

cd `dirname $0`
sudo ./files/cuda_10.1.243_418.87.00_linux.run --silent --toolkit --toolkitpath=/opt/cuda-10.1
if [ $? -ne 0 ]; then
    echo "cuda installing failed.."
    exit 1
fi
sudo tee /etc/profile.d/opt/cuda.sh << EOF
export PATH=\$PATH:/opt/cuda/bin
EOF
sudo tee /etc/ld.so.conf.d/cuda.conf << EOF
/opt/cuda/lib64
EOF
sudo rm /etc/ld.so.conf.d/cuda-10-1.conf
sudo ldconfig
cd /opt && sudo ln -sf cuda-10.1 cuda
sudo rm /usr/local/cuda
sudo ln -sf /opt/cuda /usr/local/
