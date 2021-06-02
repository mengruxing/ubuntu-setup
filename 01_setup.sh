#!/usr/bin/env bash

cd `dirname $0`

if [ -f ./local/config.sh ]; then
  . ./local/config.sh
else
  echo "missing file: ./local/config.sh, please edit it and retry.."
  exit 1
fi


./request-file.sh bxt_guc_ver8_7.bin
./request-file.sh kbl_guc_ver9_14.bin
./request-file.sh frpc

sudo apt-get install -y curl vim htop openssh-server build-essential cmake lib32gcc-5-dev dkms ffmpeg chromium-browser gparted
sudo apt-get autoremove --purge -y deja-dup webbrowser-app account-plugin-flickr *firefox*
sudo rm -f /usr/share/applications/shutdown.desktop /usr/share/applications/reboot.desktop /usr/share/applications/logout.desktop /etc/skel/examples.desktop
sudo apt-get install -y `python3 -c "from LanguageSelector.LanguageSelector import LanguageSelectorBase
print(' '.join(LanguageSelectorBase('/usr/share/language-selector/').getMissingLangPacks()))"`

sudo cp ./local/bxt_guc_ver8_7.bin ./local/kbl_guc_ver9_14.bin /lib/firmware/i915/

sudo sed -i 's/^\(Prompt\)=.*$/\1=never/g' /etc/update-manager/release-upgrades

sudo tee /etc/sysctl.d/10-vm-swappiness.conf << EOF
vm.swappiness = 10
EOF

sudo tee /etc/sysctl.d/10-max-user-watches.conf << EOF
fs.inotify.max_user_watches = 524288
EOF

sudo sed -i 's/^\s*\(HISTFILESIZE=\).*$/\110000/g;' /etc/skel/.bashrc
sudo sed -i 's/^\(.*alias\s+ls.*--color=auto\)\(.*\)$/\1 --group-directories-first\2/g' /etc/skel/.bashrc

sudo sed -i 's/\(GRUB_TIMEOUT=\)[0-9]\+/\10/' /etc/default/grub
sudo sed -i 's/[1-9][0-9]*/0/g' /usr/share/plymouth/themes/default.grub
sudo chmod -x /etc/grub.d/30_* /etc/grub.d/4*
sudo update-grub

sudo chmod -x /etc/update-motd.d/10-help-text /etc/update-motd.d/50-motd-news /etc/update-motd.d/90-updates-available /etc/update-motd.d/91-release-upgrade

sudo tee /etc/lightdm/lightdm.conf.d/guest.conf << EOF
[SeatDefaults]
allow-guest=false
EOF

if [ -n "${RECORD_HOST_NAME}" ]; then crontab << EOF
$(crontab -l)
* * * * * curl -d "hostName=${RECORD_HOST_NAME}&ipAddress=\$(hostname -I | awk '{print \$1}')" ${RECORD_URL}
EOF
fi

if [ -n "${frp_remote_port}" ] && [[ ! "${frp_remote_port}" == "no" ]]; then
  sudo cp ./local/frpc /usr/local/bin/frpc
  sudo chmod +x /usr/local/bin/frpc
  sudo mkdir /etc/frp /var/log/frp
  sudo chmod 775 /var/log/frp
  sudo chgrp nogroup /var/log/frp

  sudo tee /etc/frp/frpc.ini << EOF
[common]
server_addr = ${frp_server_addr}
server_port = ${frp_server_port}
token = ${frp_token}
log_file = /var/log/frp/frpc.log

[${frp_host_name}_ssh]
type = stcp
local_port = 22
sk = ${frp_sk}
EOF

  sudo tee /lib/systemd/system/frpc.service << EOF
[Unit]
Description=Frp Client Service
After=network.target

[Service]
Type=simple
User=nobody
Restart=on-failure
RestartSec=5s
ExecStart=/usr/local/bin/frpc -c /etc/frp/frpc.ini
ExecReload=/usr/local/bin/frpc reload -c /etc/frp/frpc.ini

[Install]
WantedBy=multi-user.target
EOF

  sudo tee /lib/systemd/system/frpc@.service << EOF
[Unit]
Description=Frp Client Service
After=network.target

[Service]
Type=idle
User=nobody
Restart=on-failure
RestartSec=5s
ExecStart=/usr/local/bin/frpc -c /etc/frp/%i.ini
ExecReload=/usr/local/bin/frpc reload -c /etc/frp/%i.ini

[Install]
WantedBy=multi-user.target
EOF

  sudo systemctl enable frpc
  sudo systemctl start frpc
fi

sudo tee /usr/share/glib-2.0/schemas/99_ubuntu_customized.gschema.override << EOF
[com.canonical.unity-greeter]
background-color = '#303030'
draw-grid = false
play-ready-sound = false

[com.canonical.unity.webapps]
preauthorized-domains = []

[com.canonical.Unity.Launcher]
favorites = ['application://org.gnome.Nautilus.desktop', 'application://chromium-browser.desktop', 'unity://running-apps', 'unity://expo-icon', 'unity://devices']

[com.canonical.indicator.keyboard]
visible = false

[com.ubuntu.update-notifier]
no-show-notifications = true

[org.gnome.Terminal.Legacy.Profile]
scrollbar-policy = 'never'

[org.gnome.gedit.preferences.editor]
tabs-size = 4
auto-indent = true
bracket-matching = true
create-backup-copy = false
display-line-numbers = true
highlight-current-line = true

[org.gnome.nautilus.window-state]
sidebar-width = 170
geometry = '960x640+65+24'

[org.gnome.desktop.session]
idle-delay = 600

[org.gnome.desktop.screensaver]
lock-delay = 30

[org.gnome.settings-daemon.plugins.media-keys]
screensaver = ''

[org.compiz.core]
active-plugins = ['core','composite','opengl','compiztoolbox','decor','vpswitch','snap','mousepoll','resize','place','move','wall','grid','regex','imgpng','session','gnomecompat','animation','fade','workarounds','scale','expo','ezoom']

[org.compiz.animation]
minimize-effects = ['animation:Glide 2']

[org.compiz.expo]
selected-color = '#555753ff'

[org.compiz.grid]
outline-color = '#555753ff'
fill-color = '#888a854f'

[org.compiz.resize]
border-color='#555753ff'
fill-color='#888a854f'

[org.compiz.gnomecompat]
run-key = '<Super>grave'

[org.compiz.matecompat]
run-key = '<Super>grave'

[org.compiz.unityshell]
launcher-minimize-window = true
panel-opacity-maximized-toggle = true
disable-show-desktop = true
show-desktop-key = '<Super>d'
spread-app-windows = '<Control><Super>Tab'
spread-app-windows-anywhere = '<Control><Super><Shift>Tab'
launcher-switcher-prev = 'Disabled'
launcher-switcher-forward = 'Disabled'
execute-command = '<Super>grave'

[org.compiz.scale]
speed = 2.0
initiate-key='<Super>Tab'
initiate-all-key='<Super><Shift>Tab'

[org.compiz.ring]
next-key = 'Disabled'
prev-key = 'Disabled'
next-all-key = 'Disabled'
prev-all-key = 'Disabled'

[org.compiz.shift]
next-key = 'Disabled'
prev-key = 'Disabled'
next-all-key = 'Disabled'
prev-all-key = 'Disabled'

[org.compiz.switcher]
next-key = 'Disabled'
prev-key = 'Disabled'
next-all-key = 'Disabled'
prev-all-key = 'Disabled'

[org.compiz.staticswitcher]
next-key = 'Disabled'
prev-key = 'Disabled'
next-all-key = 'Disabled'
prev-all-key = 'Disabled'

[org.compiz.commands]
command20 = ''
run-command20-key = 'Disabled'

[org.compiz.integrated]
command-21 = ''
run-command-21 =@as ["Disabled"]

EOF

sudo glib-compile-schemas /usr/share/glib-2.0/schemas/
