#!/bin/bash
#
# Author: Mr.x
#
# Copyright (c) http://mrxing.org
#
PATH='/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin'
cd `dirname $0`
EXEC_PATH=`pwd`

if [ ! -d "${EXEC_PATH}/log" ]; then
  mkdir "${EXEC_PATH}/log"
fi

if [ ! -f "${EXEC_PATH}/log/upgraded" ]; then
  sudo sed -i '45,$s/^.*#.*deb/deb/g' /etc/apt/sources.list
  sudo apt-get update; sudo apt-get update && sudo apt-get dist-upgrade -y
  if [ $? -eq 0 ]; then
    touch "${EXEC_PATH}/log/upgraded"
    echo '系统需要重启，建议您重启系统后再继续，是否重启？'
    read -p '(y)es/(n)o/(q)uit: ' opt
    case ${opt:='yes'} in
      'yes' | 'y')
        sudo reboot
		    ;;
      'quit' | 'q')
        exit 0
		    ;;
    esac
    unset opt
  else
    echo '更新系统失败，是否要继续下面的操作？'
    read -p '(y)es/(n)o/(q)uit: ' opt
    case ${opt} in
      'yes' | 'y')
        echo '后续操作可能会存在问题'
		    ;;
      *)
        exit 0
        ;;
    esac
    unset opt
  fi
fi

sudo apt-get install zsh -y
sudo apt-get install vim git tmux htop openssh-server build-essential cmake -y
sudo apt-get install python-dev python-pip python-numpy -y

# sudo 免密码
if [ -f "${EXEC_PATH}/sudo.sh" ] && [ ! -f "/etc/sudoers.d/${USER}" ]; then
  . "${EXEC_PATH}/sudo.sh"
fi

# swappiness
if [ -f "${EXEC_PATH}/swappiness.sh" ] && [ ! -f "/etc/sysctl.d/10-vm-swappiness.con" ]; then
  . "${EXEC_PATH}/swappiness.sh"
fi

# check file
if [ -f "${EXEC_PATH}/checkfile.sh" ]; then
  . "${EXEC_PATH}/checkfile.sh"
fi

if [ `lspci | grep NVIDIA | wc -l` -gt 0 ]; then
  echo '是否安装独显驱动？'
  read -p '(y)es/(n)o/(q)uit: ' opt
  case ${opt:='yes'} in
    'yes' | 'y')
      if [ -f "${EXEC_PATH}/nouveau.sh" ] && [ ! -f "/etc/modprobe.d/blacklist-nouveau.conf" ]; then
        . "${EXEC_PATH}/nouveau.sh"
      fi
      echo '是否通过Ubuntu软件源安装？'
      read -p '(y)es/(n)o/(q)uit: ' opt1
      case ${opt:='yes'} in
        'yes' | 'y')
          sudo apt-get install nvidia-375
          touch ${EXEC_PATH}/log/nv_installed
          cd /usr/lib/nvidia-375/
          sudo mv /usr/lib/nvidia-375/libEGL.so.1 /usr/lib/nvidia-375/libEGL.so.1.org
          sudo ln -s libEGL.so.1.org libEGL.so.1
          cd /usr/lib32/nvidia-375/
          sudo mv /usr/lib32/nvidia-375/libEGL.so.1 /usr/lib32/nvidia-375/libEGL.so.1.org
          sudo ln -s libEGL.so.1.org libEGL.so.1
          sudo ldconfig
          sudo reboot
          ;;
        'no' | 'n')
          sudo ${EXEC_PATH}/software/cuda_8.0.61_375.26_linux.run -silent -driver
          touch ${EXEC_PATH}/log/nv_installed
          sudo reboot
          ;;
        'quit' | 'q')
          exit 0
          ;;
      esac
      unset opt1
      ;;
    'quit' | 'q')
      exit 0
      ;;
  esac
  unset opt
fi

# 安装 CUDA
sudo apt-get install freeglut3-dev libglu1-mesa-dev libx11-dev libxi-dev libxmu-dev libgl1-mesa-glx
sudo ${EXEC_PATH}/software/cuda_8.0.61_375.26_linux.run
sudo tee /etc/ld.so.conf.d/cuda.conf << EOF
/opt/cuda-8.0/lib64
EOF
sudo cp ${EXEC_PATH}/software/tmp/cuda/include/cudnn.h /opt/cuda-8.0/include/
cd /opt/cuda-8.0/lib64/
sudo cp ${EXEC_PATH}/software/tmp/cuda/lib64/libcudnn.so.5.1.5 .
sudo cp ${EXEC_PATH}/software/tmp/cuda/lib64/libcudnn_static.a .
sudo ln -s libcudnn.so.5.1.5 libcudnn.so.5
sudo ln -s libcudnn.so.5 libcudnn.so
sudo ldconfig -v
sudo reboot

# grub
sudo sed -i 's/[1-9][0-9]*/0/g' /lib/plymouth/themes/ubuntu-logo/ubuntu-logo.grub

# backup hosts
sudo cp /etc/hosts /etc/hosts.bak

if [ -d "${EXEC_PATH}/bin" ]; then
  sudo cp ${EXEC_PATH}/bin/* /usr/local/bin/
fi

# 第三方 ppa
if [ -f "${EXEC_PATH}/ppa.sh" ]; then
  . "${EXEC_PATH}/ppa.sh"
fi

sudo apt-get install ubuntu-tweak unity-tweak-tool gparted nautilus-open-terminal indicator-multiload dconf-editor ubuntu-restricted-extras -y
sudo apt-get install oracle-java7-installer -y
sudo apt-get install oracle-java8-installer -y
sudo tee -a /usr/share/indicator-application/ordering-override.keyfile << EOF
multiload=-9
EOF

# 清除无用软件
sudo apt-get autoremove --purge landscape-client-ui-install xterm empathy empathy-common gnome-mahjongg gnome-mines gnome-orca gnome-sudoku -y
sudo rm /usr/share/applications/webbrowser-app.desktop /usr/share/applications/ubuntu-amazon-default.desktop /usr/share/applications/sol.desktop /usr/games/sol

# nginx
if [ -f "${EXEC_PATH}/nginx-install.sh" ]; then
  . ${EXEC_PATH}/nginx-install.sh
fi

# db
sudo apt-get install mysql-server
sudo apt-get install mongodb
# phpmyadmin
sudo apt-get install php5-fpm
sudo apt-get install phpmyadmin

# opencv
sudo apt-get install libgtk2.0-dev libavcodec-dev libavformat-dev libswscale-dev libavdevice-dev ffmpeg -y
tar -zxvf ${EXEC_PATH}/software/opencv-2.4.13.2.tar.gz -C ${EXEC_PATH}/tmp
cd ${EXEC_PATH}/tmp/opencv-2.4.13.2/
mkdir release && cd release/
cmake -D CMAKE_BUILD_TYPE=RELEASE ..
make && sudo make install && echo '------- opencv installtion succeed --------'
sudo ldconfig

# matlab
if [ -f "${EXEC_PATH}/matlab.sh"]; then
  . ${EXEC_PATH}/matlab.sh
fi

# vlfeat libsvm
sudo tar -zxvf ${EXEC_PATH}/software/vlfeat-0.9.20-bin.tar.gz -C /opt/
sudo mv /opt/vlfeat-0.9.20 /opt/vlfeat
sudo tar -zxvf ${EXEC_PATH}/software/libsvm-3.22.tar.gz -C /opt/
sudo mv /opt/libsvm-3.22 /opt/libsvm
sudo chown -R root:root /opt/libsvm/
cd /opt/libsvm/
sudo make
cd python/
sudo make
cd ./matlab/
sudo /opt/matlab/bin/glnxa64/MATLAB -nodesktop -r 'make;exit'

# caffe
sudo apt-get install libprotobuf-dev libleveldb-dev libsnappy-dev libopencv-dev libhdf5-serial-dev protobuf-compiler
sudo apt-get install --no-install-recommends libboost-all-dev
sudo apt-get install libatlas-base-dev
sudo apt-get install libgflags-dev libgoogle-glog-dev liblmdb-dev
tar -zxvf ${EXEC_PATH}/software/caffe-rc5.tar.gz -C ${EXEC_PATH}/tmp/
cd ${EXEC_PATH}/tmp/caffe-rc5/python/
for req in $(cat requirements.txt); do sudo -H pip install $req; done
cd .. && cp Makefile.config.example Makefile.config
vim Makefile.config
. ${EXEC_PATH}/caffe-make.sh

# tensorflow
sudo pip install wheel pyopenssl ndg-httpsclient pyasn1
sudo pip install ${EXEC_PATH}/software/tensorflow_gpu-1.0.1-cp27-none-linux_x86_64.whl

echo '是否需要修改桌面左上角'
read -p '(y)es/(n)o/(q)uit: ' opt
case ${opt:='yes'} in
  'yes' | 'y')
    echo 'msgid "Ubuntu Desktop"' > /tmp/unity.po
    echo 'msgstr "Ubuntu Linux"' >> /tmp/unity.po
    sudo msgfmt -o /usr/share/locale/zh_CN/LC_MESSAGES/unity.mo /tmp/unity.po
    ;;
  'quit' | 'q')
    exit 0
    ;;
esac
unset opt

release=`lsb_release -r -s`
if [ '14.04' = $release ]; then
  echo '修改壁纸属性'
  sudo chmod -x /usr/share/backgrounds/Water_web_by_Tom_Kijas.jpg
  sudo rm '/usr/share/backgrounds/Mono_Lake_by_Angela_Henderson.jpg'
  sudo sed -i '/Mono_Lake_by_Angela_Henderson.jpg/,+8d' /usr/share/backgrounds/contest/trusty.xml
  sudo rm -rf '/usr/share/icons/HighContrast'
fi

sudo tar -zxvf "${EXEC_PATH}/software/eclipse-jee-mars-2-linux-gtk-x86_64.tar.gz" -C /opt/
sudo cp /opt/eclipse/icon.xpm /usr/share/icons/eclipse.xpm
sudo cp "${EXEC_PATH}desktop/eclipse.desktop" /usr/share/applications/
