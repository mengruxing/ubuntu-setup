#!/usr/bin/env bash

cd `dirname $0`

sudo ./files/Anaconda2-2019.10-Linux-x86_64.sh -b -p /opt/anaconda2
cd /opt && sudo ln -sf anaconda2 anaconda
cd /opt/anaconda/share/icons && sudo ln -sf ../../lib/python2.7/site-packages/anaconda_navigator/app/icons/Icon1024.png anaconda-navigator.png
sudo ln -sf /opt/anaconda/share/icons/anaconda-navigator.png /usr/share/pixmaps/anaconda-navigator.png
if [ ! -d /etc/profile.d/opt ]; then
  sudo mkdir /etc/profile.d/opt
fi
sudo tee /etc/profile.d/opt/anaconda.sh << EOF
export PATH=\$PATH:/opt/anaconda/bin
EOF
sudo tee /usr/share/applications/anaconda-navigator.desktop << EOF
[Desktop Entry]
Version=1.0
Type=Application
Name=Anaconda Navigator
GenericName=Anaconda Navigator
Comment=Scientific Python Development EnviRonment
TryExec=/opt/anaconda/bin/anaconda-navigator
Exec=/opt/anaconda/bin/anaconda-navigator %F
Categories=Development;Science;IDE;Qt;
Icon=anaconda-navigator
Terminal=false
StartupNotify=true
MimeType=text/x-python;
X-AppStream-Ignore=True
EOF
