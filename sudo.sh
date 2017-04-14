#!/bin/bash
#
# Author: Mr.x
#
# Copyright (c) http://mrxing.org
#
PATH='/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin'

sudo tee /etc/sudoers.d/${USER} << EOF
${USER}	ALL=(ALL)	NOPASSWD:	ALL
EOF
sudo chmod 440 /etc/sudoers.d/${USER}
