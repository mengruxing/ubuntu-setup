#!/usr/bin/env bash

cd `dirname $0`
sh_file=${0##*/}
entrypoint_file="$(pwd)/${sh_file}"
PROJECT_PATH="`pwd`"

sleep_time=30

if [ -z `grep "${entrypoint_file}" /etc/rc.local` ]; then
  sleep_time=3
  sudo sed -i "/^\s*exit\s\+[0-9]\+\$/i\\${entrypoint_file} &" /etc/rc.local
fi

if [ ! -e tmp ]; then
  sleep_time=3
  mkdir tmp
fi

if [ ! -f ./local/config.sh ]; then
  sleep_time=3
  if [ ! -e privacy.sh ]; then
    tee privacy.sh > /dev/null << EOF
#!/usr/bin/env bash

# https://<HOST>/api/commit
RECORD_URL=

frp_server_addr=
frp_token=
frp_server_port=7000
EOF
    chmod +x privacy.sh
    echo 'please edit privacy.sh and retry..'
    exit 1
  elif [ "`md5sum privacy.sh | awk '{print $1}'`" == "7b0c8166361eeca687a80f57d69c7a2f" ]; then
    echo 'privacy.sh is default file, please edit it and retry..'
    exit 1
  else
    source privacy.sh
  fi

  typeset -l frp_host_name
  typeset -l opt_nvidia_driver
  typeset -l opt_override_opengl

  frp_host_name=${HOSTNAME//-/_}
  default_record_hostname=`echo ${HOSTNAME//-/_} | sed -e "s/\b\(.\)/\u\1/g"`

  if [ -n "${frp_server_addr}" ] && [ -n "${frp_server_port}" ] && [ -n "${frp_token}" ]; then
    read -p 'please input frp_sk: ' frp_sk
  fi

  if [[ -n "${RECORD_URL}" ]]; then
    read -p "please input the hostName to report to IpRecorder [${default_record_hostname}] (empty denotes not to report): " opt_record_hostname
  fi

  read -p "whether or not to install nvidia driver and docker support? (default: yes) (y)es/(n)o: " opt_nvidia_driver
  case ${opt_nvidia_driver:=yes} in
    'yes' | 'y' )
      read -p "whether or not to override  system opengl libs? (default: yes) (y)es/(n)o: " opt_override_opengl
      case ${opt_override_opengl:=yes} in
        'yes' | 'y' )
          nvidia_cuda_opts=''
          ;;
        * )
          nvidia_cuda_opts='--no-opengl-files'
          ;;
      esac
      ;;
  esac

  tee ./local/config.sh << EOF
#!/usr/bin/env bash

frp_server_addr=${frp_server_addr}
frp_server_port=${frp_server_port}
frp_token=${frp_token}
frp_host_name=${frp_host_name}
frp_sk=${frp_sk}

RECORD_URL=${RECORD_URL}
RECORD_HOST_NAME=${opt_record_hostname}

opt_nvidia_driver=${opt_nvidia_driver}
nvidia_cuda_opts='${nvidia_cuda_opts}'

EOF
  chmod +x ./local/config.sh
  echo 'system will be reboot 3 times, please wait patiently..'
fi

sleep ${sleep_time}
source ./local/config.sh
sudo service `sed 's/^.*\///g' /etc/X11/default-display-manager` stop

if [ ! -f tmp/step_00_apt_update ]; then
  ./00_apt-update.sh 2>&1 | tee tmp/step_00_apt_update.log && touch tmp/step_00_apt_update
  sudo reboot
fi

if [ ! -f tmp/step_01_setup ]; then
  ./01_setup.sh 2>&1 | tee tmp/step_01_setup.log && touch tmp/step_01_setup
  sudo reboot
fi

if [[ "${opt_nvidia_driver}" == "yes" ]]; then
  if [ ! -f tmp/nvidia_step_0 ]; then
    echo 'installing nvidia driver from source.. after than, system will be reboot.'
    ./10_nvidia-preinstall.sh 2>&1 | tee tmp/nvidia_step_0.log && touch tmp/nvidia_step_0
    sudo reboot
  fi
  if [ ! -f tmp/nvidia_step_1 ]; then
    echo 'installing nvidia driver from source.. after than, system will be reboot.'
    ./11_nvidia-driver.sh 2>&1 | tee tmp/nvidia_step_1.log && touch tmp/nvidia_step_1
    sudo reboot
  fi
  if [ ! -f tmp/nvidia_step_2 ]; then
    echo 'installing nvidia driver from source.. after than, system will be reboot.'
    ./12_nvidia-cuda.sh 2>&1 | tee tmp/nvidia_step_2.log && touch tmp/nvidia_step_2
    sudo reboot
  fi
  if [ ! -f tmp/nvidia_step_3 ]; then
    echo 'installing nvidia driver from source.. after than, system will be reboot.'
    ./13_nvidia-docker.sh 2>&1 | tee tmp/nvidia_step_3.log && touch tmp/nvidia_step_3
    sudo reboot
  fi
fi

if [ ! -f tmp/step_20_desktop_apps ]; then
  ./20_desktop-apps.sh 2>&1 | tee tmp/step_20_desktop_apps.log && touch tmp/step_20_desktop_apps
fi

if [[ ! "${install_anaconda}" == "no" ]] && [ ! -f tmp/step_21_anaconda ]; then
  ./21_anaconda.sh 2>&1 | tee tmp/step_21_anaconda.log && touch tmp/step_21_anaconda
fi

if [ ! -f tmp/step_21_miniconda ]; then
  ./21_miniconda.sh 2>&1 | tee tmp/step_21_miniconda.log && touch tmp/step_21_miniconda
fi

if [[ ! "${install_ide}" == "no" ]] && [ ! -f tmp/step_22_ide ]; then
  ./22_ide.sh 2>&1 | tee tmp/step_22_ide.log && touch tmp/step_22_ide
fi

if [ ! -f tmp/step_30_post_install ]; then
  ./30_post-install.sh 2>&1 | tee tmp/step_30_post_install.log && touch tmp/step_30_post_install
  sudo sed -i "/${sh_file}/d" /etc/rc.local
  echo '!!!!!!!!!!!!!!!!! FILISHED !!!!!!!!!!!!!!!!!' && sleep 60 && sudo reboot
fi
