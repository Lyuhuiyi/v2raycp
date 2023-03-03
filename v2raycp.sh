#!/bin/bash
# author:toufei

echo "正在/opt 创建xray文件夹 \n"
cd /opt
rm /opt/xray/Xray-linux-64.zip
mkdir xray
cd /opt/xray

echo "正在下载xray 1.7.3 \n"
wget https://github.com/XTLS/Xray-core/releases/download/v1.7.3/Xray-linux-64.zip
unzip Xray-linux-64.zip

echo "正在安装nginx和pwgen 如果没有进行apt update 请手动执行一次 \n"
apt-get install nginx pwgen screen unzip -y

echo "获取acme中 \n"
curl https://get.acme.sh | sh

cd /opt
mkdir cert
cd

echo "当前正在进行证书注册 \n"
bash ~/.acme.sh/acme.sh --set-default-ca --server letsencrypt

echo "请输入当前机器的完整域名 \n"
read -e yuming

service nginx stop
page=$(pwgen -c 12)


echo "正在注册 \n"
cmd1="bash ~/.acme.sh/acme.sh --issue -d '$yuming' -k ec-256 --alpn"
$cmd1

echo "正在获取证书"
cmd2="bash ~/.acme.sh/acme.sh --installcert -d '$yuming' --fullchainpath /opt/cert/fullchain.crt --keypath /opt/cert/site.key --ecc"
$cmd2

sed "0,$d" /etc/nginx/sites-available/default
ht='server {
	listen 80;
	server_name $yuming;
	return 301 https://$host$request_uri;
}


server {
	listen 443 ssl http2 default_server;
	listen [::]:443 ssl http2 default_server;
	server_name $yuming;

	ssl_certificate /opt/cert/fullchain.crt;
	ssl_certificate_key /opt/cert/site.key;
	ssl_ciphers EECDH+CHACHA20:EECDH+CHACHA20-draft:EECDH+ECDSA+AES128:EECDH+aRSA+AES128:RSA+AES128:EECDH+ECDSA+AES256:EECDH+aRSA+AES256:RSA+AES256:EECDH+ECDSA+3DES:EECDH+aRSA+3DES:RSA+3DES:!MD5;
	ssl_protocols TLSv1.1 TLSv1.2 TLSv1.3;

	location = / {
		index /usr/share/nginx/index.html;

	}

	location /$page {
		proxy_redirect off;
		proxy_pass http://127.0.0.1:1234;
		proxy_http_version 1.1;
		proxy_set_header Upgrade $http_upgrade;
		proxy_set_header Connection "upgrade";
		proxy_set_header Host $http_host;
	}

}
'
echo $ht >> /etc/nginx/sites-available/default

echo "正在尝试打开nginx"
service nginx start
service nginx force-reload

echo "在此输入你想给xray用的uuid"
read -e uid

config='{
  "log" : {
    "loglevel": "warning"
  },
  "inbound": {
    "port": 1234,
    "listen": "127.0.0.1",
    "protocol": "vless",
    "settings": {
      "decryption":"none",
      "clients": [
        {
          "id": "$uid",
          "level": 1
        }
      ]
    },
   "streamSettings":{
      "network": "ws",
      "wsSettings": {
           "path": "/$page"
      }
   }
  },
  "outbound": {
    "protocol": "freedom",
    "settings": {
      "decryption":"none"
    }
  },
  "outboundDetour": [
    {
      "protocol": "blackhole",
      "settings": {
        "decryption":"none"
      },
      "tag": "blocked"
    }
  ],
  "routing": {
    "strategy": "rules",
    "settings": {
      "decryption":"none",
      "rules": [
        {
          "type": "field",
          "ip": [ "geoip:private" ],
          "outboundTag": "blocked"
        }
      ]
    }
  }
}
'

echo $config >> /opt/xray/config.json

echo "正在使用screen打开xray"

cd /opt/xray

screen -dmS xray ./xray -c /opt/xray/config.json

cd

echo $yuming >> /opt/v2raycp.save
echo $page >> /opt/v2raycp.save
echo $uid >> /opt/v2raycp.save

echo "-----end-----"











