#!/usr/bin/env bash

cd `dirname $0`

if [ -f tmp/config.sh ]; then
  source tmp/config.sh
else
  echo "missing file: tmp/config.sh, please edit it and retry.."
  exit 1
fi

sudo service lightdm stop

sudo ./files/NVIDIA-Linux-x86_64-430.50.run --ui=none --no-questions --accept-license --disable-nouveau --dkms ${nvidia_cuda_opts}

if [[ "${nvidia_cuda_opts}" == *no*opengl* ]]; then
  sudo rm /usr/share/applications/nvidia-settings.desktop
else
  sudo ln -s /usr/share/doc/NVIDIA_GLX-1.0/nvidia-settings.png /usr/share/pixmaps/nvidia-settings.png
  sudo tee /usr/share/applications/nvidia-settings.desktop << EOF
[Desktop Entry]
Type=Application
Encoding=UTF-8
Name=NVIDIA X Server Settings
Comment=Configure NVIDIA X Server Settings
Icon=nvidia-settings
Exec=/usr/bin/nvidia-settings
Categories=Settings;HardwareSettings;
EOF
fi
