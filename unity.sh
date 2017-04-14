#!/bin/bash
#
# Author: Mr.x
#
# Copyright (c) http://mrxing.org
#
PATH='/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin'

tee /tmp/unity.po << EOF
msgid "Ubuntu Desktop"
msgstr "Ubuntu Linux"
EOF
sudo msgfmt -o /usr/share/locale/zh_CN/LC_MESSAGES/unity.mo /tmp/unity.po
