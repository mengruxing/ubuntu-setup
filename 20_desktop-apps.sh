#!/usr/bin/env bash

cd `dirname $0`

echo "-----BEGIN PGP PUBLIC KEY BLOCK-----
Version: GnuPG v1.4.7 (GNU/Linux)

mQENBFYxWIwBCADAKoZhZlJxGNGWzqV+1OG1xiQeoowKhssGAKvd+buXCGISZJwT
LXZqIcIiLP7pqdcZWtE9bSc7yBY2MalDp9Liu0KekywQ6VVX1T72NPf5Ev6x6DLV
7aVWsCzUAF+eb7DC9fPuFLEdxmOEYoPjzrQ7cCnSV4JQxAqhU4T6OjbvRazGl3ag
OeizPXmRljMtUUttHQZnRhtlzkmwIrUivbfFPD+fEoHJ1+uIdfOzZX8/oKHKLe2j
H632kvsNzJFlROVvGLYAk2WRcLu+RjjggixhwiB+Mu/A8Tf4V6b+YppS44q8EvVr
M+QvY7LNSOffSO6Slsy9oisGTdfE39nC7pVRABEBAAG0N01pY3Jvc29mdCAoUmVs
ZWFzZSBzaWduaW5nKSA8Z3Bnc2VjdXJpdHlAbWljcm9zb2Z0LmNvbT6JATUEEwEC
AB8FAlYxWIwCGwMGCwkIBwMCBBUCCAMDFgIBAh4BAheAAAoJEOs+lK2+EinPGpsH
/32vKy29Hg51H9dfFJMx0/a/F+5vKeCeVqimvyTM04C+XENNuSbYZ3eRPHGHFLqe
MNGxsfb7C7ZxEeW7J/vSzRgHxm7ZvESisUYRFq2sgkJ+HFERNrqfci45bdhmrUsy
7SWw9ybxdFOkuQoyKD3tBmiGfONQMlBaOMWdAsic965rvJsd5zYaZZFI1UwTkFXV
KJt3bp3Ngn1vEYXwijGTa+FXz6GLHueJwF0I7ug34DgUkAFvAs8Hacr2DRYxL5RJ
XdNgj4Jd2/g6T9InmWT0hASljur+dJnzNiNCkbn9KbX7J/qK1IbR8y560yRmFsU+
NdCFTW7wY0Fb1fWJ+/KTsC4=
=J6gs
-----END PGP PUBLIC KEY BLOCK-----
" | gpg --dearmor > /tmp/microsoft.gpg
sudo cp /tmp/microsoft.gpg /etc/apt/trusted.gpg.d/microsoft.gpg

sudo tee /etc/apt/sources.list.d/vscode.list << EOF
### THIS FILE IS AUTOMATICALLY CONFIGURED ###
# You may comment out this entry, but any other modifications may be lost.
deb [arch=amd64] http://packages.microsoft.com/repos/vscode stable main
EOF

wget -qO - https://packagecloud.io/AtomEditor/atom/gpgkey | sudo apt-key add -
sudo tee /etc/apt/sources.list.d/atom.list << EOF
deb [arch=amd64] https://packagecloud.io/AtomEditor/atom/any/ any main
EOF

sudo cp ./files/sogou-archive-keyring.gpg /etc/apt/trusted.gpg.d/sogou-archive-keyring.gpg
sudo tee /etc/apt/sources.list.d/sogoupinyin.list << EOF
deb http://archive.ubuntukylin.com:10006/ubuntukylin xenial main
EOF

sudo add-apt-repository -y ppa:webupd8team/terminix
sudo apt-add-repository -y ppa:mc3man/older
sudo apt update
sudo apt install -y tilix atom code gedit gedit-common

cd /etc/profile.d && sudo ln -s vte-2.91.sh vte.sh
cd -

if [ -z "$(grep 'vte.sh' ~/.bashrc 2>/dev/null)" ]; then
  tee -a ~/.bashrc << EOF

if [ \$TILIX_ID ] || [ \$VTE_VERSION ]; then
  . /etc/profile.d/vte.sh
fi

EOF
fi

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
