#!/bin/bash
#
# Author: Mr.x
#
# Copyright (c) http://mrxing.org
#
PATH='/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin'
cd `dirname $0`
EXEC_PATH=`pwd`

sudo mkdir /opt/matlab ${EXEC_PATH}/mnt
sudo mount -t auto -o loop ${EXEC_PATH}/software/R2015b_glnxa64.iso ${EXEC_PATH}/mnt
cp ${EXEC_PATH}/matlab/crack/license_standalone.lic /tmp/license_standalone_2015b.lic
cd /opt/matlab/
sudo ${EXEC_PATH}/mnt/install -inputFile ${EXEC_PATH}/matlab/installer_input.txt -activationPropertiesFile ${EXEC_PATH}/matlab/activate.ini
sudo umount ${EXEC_PATH}/mnt
sudo /opt/matlab/bin/glnxa64/MATLAB
cd /opt/matlab/bin/glnxa64/
sudo cp ${EXEC_PATH}/matlab/standalone/bin/glnxa64/* .
sudo ln -s libSDL2-2.0.so.1 libSDL2-2.0.so
sudo cp /opt/matlab/toolbox/nnet/nnresource/icons/matlab.png /usr/share/icons/
sudo cp ${EXEC_PATH}/desktop/matlab.desktop /usr/share/applications/
sudo rm -rf ~/.matlab/
