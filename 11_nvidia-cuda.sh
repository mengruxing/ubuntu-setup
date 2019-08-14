#!/usr/bin/env bash

cd `dirname $0`

if [[ "${1}" == *no*opengl* ]]; then
  opts='--no-opengl-libs'
fi

sudo service lightdm stop
sudo apt purge -y nvidia-384
sudo apt install -y nvidia-prime nvidia-settings

sudo tee /etc/modprobe.d/blacklist-nouveau.conf << EOF
blacklist nouveau
options nouveau modeset=0
EOF
sudo update-initramfs -u
sudo ./files/cuda_9.2.148_396.37_linux.run --silent --driver --toolkit --toolkitpath=/opt/cuda-9.2 --verbose ${opts}
cd /opt
sudo ln -sf cuda-9.2 cuda
sudo ln -sf /opt/cuda/libnvvp/icon.xpm /usr/share/pixmaps/nvvp.xpm
sudo ln -sf /opt/cuda/libnsight/icon.xpm /usr/share/pixmaps/nsight.xpm
sudo ln -s /usr/share/doc/NVIDIA_GLX-1.0/nvidia-settings.png /usr/share/pixmaps/nvidia-settings.png
cd -

sudo tee /usr/share/applications/nvvp.desktop << EOF
[Desktop Entry]
Type=Application
Name=NVIDIA Visual Profiler
GenericName=NVIDIA Visual Profiler
Icon=nvvp
Exec=/opt/cuda/bin/nvvp
TryExec=/opt/cuda/bin/nvvp
Keywords=nvvp;cuda;gpu;nsight;
X-AppInstall-Keywords=nvvp;cuda;gpu;nsight;
X-GNOME-Keywords=nvvp;cuda;gpu;nsight;
Terminal=No
Categories=Development;Profiling;ParallelComputing
EOF

sudo tee /usr/share/applications/nsight.desktop << EOF
[Desktop Entry]
Type=Application
Name=Nsight Eclipse Edition
GenericName=Nsight Eclipse Edition
Icon=nsight
Exec=/opt/cuda/bin/nsight
TryExec=/opt/cuda/bin/nsight
Keywords=cuda;gpu;nvidia;debugger;
X-AppInstall-Keywords=cuda;gpu;nvidia;debugger;
X-GNOME-Keywords=cuda;gpu;nvidia;debugger;
Terminal=No
Categories=Development;IDE;Debugger;ParallelComputing
EOF

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

cat /var/log/nvidia-installer.log && sleep 3 && reboot
