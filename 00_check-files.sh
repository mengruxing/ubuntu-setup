#!/usr/bin/env bash

cd `dirname $0`

# 获取下载地址
echo '正在测试下载服务器..'
curl -sf --connect-timeout 10 https://dl.anview.tech
if [ $? -eq 0 ]; then
    DOWNLOAD_ADDR='https://dl.anview.tech/ubuntu-setup-files/'
else
    DOWNLOAD_ADDR="http://`curl -s ip.anview.ai/api/host/anview/ip`:888/files/ubuntu-setup-files/"
fi

date_start=$(date '+%s')

cd ./files

# 读取 MD5 文件中的每一行
while read md5 file
do {
    echo "$md5 --> $file"
    # if [ -z "$file" ]; then
    #     # 文件为空, 跳过
    #     continue
    # fi
    if [ -f "$file" ]; then
        # 检查文件的 MD5
        checked_md5=`md5sum $file | awk '{print $1}'`
        if [ ${md5} != ${checked_md5} ]; then
            # MD5 不一致, 加入异常队列
            exc_file_list=(${exc_file_list[@]} $file)
        fi
    else
        # 文件不存在, 下载
        echo "正在下载: ${file}"
        wget -q --timeout=10 $DOWNLOAD_ADDR${file}
        if [ $? -ne 0 ]; then
            # 下载失败, 加入重新下载队列
            echo "${file} 下载失败!"
            dl_list=(${dl_list[@]} $file)
        fi
    fi
} &
done < MD5SUMS; wait

echo "检测用时: $[ $(date '+%s') - $date_start ] 秒。"

# 如果有文件下载失败, 则显示
if [ ${#dl_list[@]} -ne 0 ]; then
    echo -e "以下文件下载失败:\n\n${dl_list[*]}"
fi

# 如果异常队列为空, 直接退出
if [ ${#exc_file_list[@]} -eq 0 ]; then
    exit 0
fi

echo -e "以下文件的MD5验证不一致:\n\n${exc_file_list[*]}\n\n是否重新下载？<[(y)es]>/(n)o/(q)uit: "
read -t 10 opt
case ${opt:='yes'} in
    'yes' | 'y')
        for file in ${exc_file_list[@]}; do
        {
            echo "正在下载: ${file}"
            wget $DOWNLOAD_ADDR${file}
        } &
        done; wait
        ;;
    'quit' | 'q')
        exit 1
        ;;
esac
