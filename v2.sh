#!/bin/bash
# author:toufei

echo "正在/opt 创建xray文件夹"
cd /opt
mkdir xray

echo "正在下载xray 1.7.3"
wget https://github.com/XTLS/Xray-core/releases/download/v1.7.3/Xray-linux-64.zip
unzip Xray-linux-64.zip

echo "正在安装nginx 如果没有进行apt update 请手动执行一次"
apt-get install nginx
