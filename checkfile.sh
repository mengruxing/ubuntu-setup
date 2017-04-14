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

files=`awk '{print $2}' ${EXEC_PATH}/software/check.md5sum`
cd software/
for file in $files; do
{
  if [ -f "${EXEC_PATH}/software/$file" ]; then
    md5=`grep ${file} ${EXEC_PATH}/software/check.md5sum | awk '{print $1}'`
    check_md5=`md5sum ${EXEC_PATH}/software/$file | awk '{print $1}'`
    if [ ${md5} != ${check_md5} ]; then
      echo "${file} 文件校验码错误！"
    fi
  else
    echo "正在下载 ${file} .."
    wget http://station.mrxing.org/downloads/setup/${file}
  fi
} &
done; wait
