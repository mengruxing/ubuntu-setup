#!/usr/bin/env bash

cd `dirname $0`

if [ -f ./local/config.sh ]; then
  . ./local/config.sh
else
  echo "missing file: ./local/config.sh, please edit it and retry.."
  exit 1
fi

./request-file.sh NVIDIA-Linux-x86_64-430.64.run
chmod +x ./local/NVIDIA-Linux-x86_64-430.64.run

sudo service lightdm stop

sudo ./local/NVIDIA-Linux-x86_64-430.64.run --ui=none --no-questions --accept-license --disable-nouveau --dkms ${nvidia_cuda_opts}

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
