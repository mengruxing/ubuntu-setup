#!/usr/bin/env bash

cd `dirname $0`

sudo add-apt-repository -y ppa:webupd8team/terminix
sudo apt-add-repository -y ppa:mc3man/older
sudo apt-get update
sudo apt-get install -y tilix gedit gedit-common

cd /etc/profile.d && sudo ln -s vte-2.91.sh vte.sh
cd -

if [ -z "$(grep 'vte.sh' /etc/skel/.bashrc 2>/dev/null)" ]; then
  sudo tee -a /etc/skel/.bashrc << EOF

if [ \$TILIX_ID ] || [ \$VTE_VERSION ]; then
  . /etc/profile.d/vte.sh
fi

EOF
fi

sudo tee /usr/share/glib-2.0/schemas/50_tilix.gschema.override << EOF
[com.gexperts.Tilix]
warn-vte-config-issue = false

[com.gexperts.Tilix.Settings]
terminal-title-style = 'none'
app-title = '\${appName}\${activeTerminalTitle} [\${columns}x\${rows}]'
prompt-on-close-process = false

[com.gexperts.Tilix.Profile]
default-size-columns = 150
default-size-rows = 50
show-scrollbar = false
EOF

sudo glib-compile-schemas /usr/share/glib-2.0/schemas/
