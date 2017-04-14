#!/bin/bash
#
# Author: Mr.x
#
# Copyright (c) http://mrxing.org
#
PATH='/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin'

sudo tee /etc/sysctl.d/10-vm-swappiness.conf << EOF
vm.swappiness = 10
EOF
