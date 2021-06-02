#!/usr/bin/env bash

cd `dirname $0`
cd ./local

for server_addr in dl.guet.anview.tech dl.anview.tech dl.anview.ai; do
    curl -sf --connect-timeout 10 -L http://${server_addr} > /dev/null && break
done

DOWNLOAD_ADDR="http://${server_addr}/ubuntu-setup-files/"

for file in "${@}"
do {
    md5_storaged=`grep "${file}" MD5SUMS | awk '{print $1}'`
    if [ -z "${md5_storaged}" ]; then
        echo "文件不存在MD5: ${file}"
        continue
    fi
    if [ -f ${file} ]; then
        md5_checkd=`md5sum ${file} | awk '{print $1}'`
        if [ "${md5_storaged}" == "${md5_checkd}" ]; then
            echo "本地文件校验一致: ${file}"
        else
            rm -f ${file}
            wget -q --timeout=10 ${DOWNLOAD_ADDR}${file}
            echo "downloaded: ${DOWNLOAD_ADDR}${file}"
        fi
    else
        wget -q --timeout=10 ${DOWNLOAD_ADDR}${file}
        echo "downloaded: ${DOWNLOAD_ADDR}${file}"
    fi
} &
done; wait
