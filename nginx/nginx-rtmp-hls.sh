#!/bin/bash

PATH='/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin'
umask 002
name=$1
prefix=`sed -n 's/.ts//p' /tmp/hls/${name}.m3u8`
echo '' >> /tmp/rtmp-hls-${name}.log
date >> /tmp/rtmp-hls-${name}.log

# matlab作业队列
if [ ! -d /tmp/hls-job ]; then
  mkdir /tmp/hls-job
fi

# 操作记录
if [ ! -d /tmp/hls-log ]; then
  mkdir /tmp/hls-log
fi

# 判断视频文件操作记录 添加到队列中
declare -a job_files
file_num = 0;
for file in ${prefix}; do
  if [ ! -e /tmp/hls-log/${file} ]; then
    touch /tmp/hls-log/${file}
    touch /tmp/hls-job/${file}
    echo $file >> /tmp/rtmp-hls-${name}.log
    if [ -e /tmp/hls-job/${file} ]; then
      job_files[$file_num]=${file}
      let file_num+=1
      if test -z "${param}"; then
        param="'${file}'"
      else
        param="${param}, '${file}'"
      fi
    fi
  fi
done

echo "file_num: ${file_num}" >> /tmp/rtmp-hls-${name}.log
echo "param: ${param}" >> /tmp/rtmp-hls-${name}.log
echo "job_files: ${job_files[*]}" >> /tmp/rtmp-hls-${name}.log
