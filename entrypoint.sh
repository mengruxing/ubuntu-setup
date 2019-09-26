#!/usr/bin/env bash

cd `dirname $0`
sh_file=${0##*/}
entrypoint_file="$(pwd)/${sh_file}"

sleep_time=30

if [ -z `grep "${entrypoint_file}" /etc/rc.local` ]; then
  sleep_time=3
  sudo sed -i "/^\s*exit\s\+[0-9]\+\$/i\\${entrypoint_file} &" /etc/rc.local
fi

if [ ! -e tmp ]; then
  sleep_time=3
  mkdir tmp
fi

if [ ! -f tmp/config.sh ]; then
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
    read -p 'please input frp remote port [7001-7009] (empty denotes not to register): ' opt_frp_port
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

  tee tmp/config.sh << EOF
#!/usr/bin/env bash

frp_server_addr=${frp_server_addr}
frp_server_port=${frp_server_port}
frp_token=${frp_token}
frp_host_name=${frp_host_name}
frp_remote_port=${opt_frp_port}

RECORD_URL=${RECORD_URL}
RECORD_HOST_NAME=${opt_record_hostname}

opt_nvidia_driver=${opt_nvidia_driver}
nvidia_cuda_opts='${nvidia_cuda_opts}'

EOF
  chmod +x tmp/config.sh
  echo 'system will be reboot 3 times, please wait patiently..'
fi

sleep ${sleep_time}
source tmp/config.sh
sudo service lightdm stop

if [ ! -f tmp/step_0 ]; then
  echo 'execute step 1..'
  ./00_apt-update.sh 2>&1 | tee tmp/step_0.log && touch tmp/step_0
  sudo reboot
fi

if [ ! -f tmp/step_1 ]; then
  echo 'execute step 2..'
  ./01_setup.sh 2>&1 | tee tmp/step_1.log && touch tmp/step_1
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
    ./12_nvidia-docker.sh 2>&1 | tee tmp/nvidia_step_2.log && touch tmp/nvidia_step_2
    sudo reboot
  fi
fi

if [ ! -f tmp/step_2 ]; then
  echo 'execute step 3..'
  ./20_desktop-apps.sh 2>&1 | tee tmp/step_2.log && touch tmp/step_2
fi

if [ ! -f tmp/step_3 ]; then
  echo 'execute step 4..'
  ./21_anaconda.sh 2>&1 | tee tmp/step_3.log && touch tmp/step_3
fi

if [ ! -f tmp/step_4 ]; then
  echo 'execute step 5..'
  ./30_post-install.sh 2>&1 | tee tmp/step_4.log && touch tmp/step_4
  sudo sed -i "/${sh_file}/d" /etc/rc.local
  echo '!!!!!!!!!!!!!!!!! FILISHED !!!!!!!!!!!!!!!!!' && sleep 60 && sudo reboot
fi
