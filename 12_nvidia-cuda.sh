#!/usr/bin/env bash

cd `dirname $0`

if [ -f ./local/config.sh ]; then
  . ./local/config.sh
else
  echo "missing file: ./local/config.sh, please edit it and retry.."
  exit 1
fi

./request-file.sh cuda_11.1.1_455.32.00_linux.run
chmod +x ./local/cuda_11.1.1_455.32.00_linux.run

sudo ./local/cuda_11.1.1_455.32.00_linux.run --silent --toolkit --toolkitpath=/opt/cuda-11.1
if [ $? -ne 0 ]; then
    echo "cuda installing failed.."
    exit 1
fi
sudo tee /etc/profile.d/opt-cuda.sh << EOF
export PATH=\$PATH:/opt/cuda/bin
EOF
sudo tee /etc/ld.so.conf.d/cuda.conf << EOF
/opt/cuda/lib64
EOF
sudo rm /etc/ld.so.conf.d/cuda-11-1.conf
sudo ldconfig
cd /opt && sudo ln -sf cuda-11.1 cuda
sudo rm /usr/local/cuda
sudo ln -sf /opt/cuda /usr/local/

if [[ "${nvidia_cuda_opts}" == *no*opengl* ]]; then
  sudo rm /usr/share/applications/nvvp.desktop /usr/share/applications/nsight*.desktop
else
  echo 'pass'
fi
