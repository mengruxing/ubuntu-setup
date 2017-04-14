#!/bin/bash
#
# 多线程检测文件
#
# Author: Mr.x
#
# Copyright (c) http://mrxing.org
#
PATH='/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin'
cd `dirname $0`
EXEC_PATH=`pwd`

if [ -f "${EXEC_PATH}/software/.gitignore" ]; then
  rm "${EXEC_PATH}/software/.gitignore"
fi

files=`awk '{print $2}' ${EXEC_PATH}/software/check.md5sum`
for file in $files; do
  echo "${file}" >> ${EXEC_PATH}/software/.gitignore
done; wait
