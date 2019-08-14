#!/usr/bin/env bash

if [ ! -e /etc/X11/xorg.conf ] || [ -n "$(grep 'ServerFlags' /etc/X11/xorg.conf)" ]; then
  sudo tee -a /etc/X11/xorg.conf << EOF
Section "ServerFlags"
	Option	"DontVTSwitch"	"true"
EndSection
EOF
fi
