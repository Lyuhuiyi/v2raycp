#!/bin/bash

sh_ver="1.0.0"
v2ray_folder="/usr/bin/v2ray"
v2ray_config="/etc/v2ray/config.json"
v2ray_config_folder="/etc/v2ray"
v2ray_systemd="/etc/systemd/system/v2ray.service"
v2ray_systemd_folder="/etc/systemd/system"
v2ray_sysv="/etc/init.d/v2ray"
v2ray_sysv_folder="/etc/init.d"
linshi_download="/home/linshi/v2ray"
linshi_v2ray="/home/linshi/v2ray/v2ray"
linshi_v2ctl="/home/linshi/v2ray/v2ctl"
linshi_geoip="/home/linshi/v2ray/geoip.dat"
linshi_geosite="/home/linshi/v2ray/geosite.dat"
linshi_config="/home/linshi/v2ray/vpoint_vmess_freedom.json"
linshi_systemd="/home/linshi/v2ray/systemd/v2ray.service"
linshi_sysv="/home/linshi/v2ray/systemv/v2ray"

#function

v2ray_stop(){
	systemctl stop v2ray.service
}

v2ray_start(){
	systemctl start v2ray.service
}

v2ray_restart(){
	systemctl restart v2ray.service
}

check_v2ray_status(){
	
	check_failed=`systemctl status v2ray.service | grep "Failed to start V2Ray Service."`
	if [[ -z $check_failed ]]; then
		check_start=`systemctl status v2ray.service | grep "active (running)"`
		if [[ -z $check_start ]]; then
			echo "v2ray is not working"
		else
			check_stop=`systemctl status v2ray.service | grep "Stopped V2Ray Service."`
			if [[ -z $check_stop ]]; then	
				echo "v2ray is working"
			else
				echo "v2ray is stopped"
			fi
		fi
	else
		echo "v2ray is failed to start, please check your config"
	fi
}

show_config(){
	find /usr/bin/v2ray/data.json | grep "user" /usr/bin/v2ray/data.json
}

exitla(){
	exit 1
}

24h_v2ray(){
	systemctl enable v2ray
}

24h_v2rayno(){
	systemctl disable v2ray
}

check_root(){
	if [[ $EUID != 0 ]]; then
		echo "you should run this script as root"
		exitla
	else
		echo "you are root"
	fi
}

check_sys(){
	if [[ -f /etc/redhat-release ]]; then
		release="centos"
	elif cat /etc/issue | grep -q -E -i "debian"; then
		release="debian"
	elif cat /etc/issue | grep -q -E -i "ubuntu"; then
		release="ubuntu"
	elif cat /etc/issue | grep -q -E -i "centos|red hat|redhat"; then
		release="centos"
	elif cat /proc/version | grep -q -E -i "debian"; then
		release="debian"
	elif cat /proc/version | grep -q -E -i "ubuntu"; then
		release="ubuntu"
	elif cat /proc/version | grep -q -E -i "centos|red hat|redhat"; then
		release="centos"
    fi
	bit=`uname -m`
}

check_pythoncontrol(){
	check_controlfile=`find /etc/v2ray/ -name v2raycp.py`
	if [[ -z $check_controlfile ]]; then
		echo -e "you need to download v2raycp.py to control your v2ray config"
		mkdir -p $linshi_download
		cd $linshi_download
		wget http://serrule.com/download/my/v2raycp.py
		mkdir -p $v2ray_config_folder
		mv /home/linshi/v2ray/v2raycp.py $v2ray_config_folder
	else
		echo -e "you have already downloaded v2raycp.py in /etc/v2ray "
	fi
}

check_v2rayinstallation(){
	checkv2ray=`find /etc/systemd/system -name v2ray.service`
	if [[ -z $checkv2ray ]];then
		echo "there are errors when you are installing v2ray"
		exitla
	else 
		echo "you install v2ray successfully"
		exitla
	fi
}
#modify_config(){}
install_v2ray(){
	mkdir -p $linshi_download
	mkdir -p $v2ray_folder
	mkdir -p $v2ray_config_folder
	mkdir -p $v2ray_systemd_folder
	mkdir -p $v2ray_sysv_folder
	cd $linshi_download
	if ! wget "https://github.com/v2ray/v2ray-core/releases/download/v4.25.1/v2ray-linux-64.zip"; then 
		echo -e "download failed" && rm -rf "/home/linshi" && exitla
		fi
	unzip "v2ray-linux-64.zip"
	cp $linshi_v2ray $v2ray_folder
	cp $linshi_v2ctl $v2ray_folder
	cp $linshi_geoip $v2ray_folder
	cp $linshi_geosite $v2ray_folder
	cp $linshi_config $v2ray_config
	cp $linshi_systemd $v2ray_systemd
	cp $linshi_sysv $v2ray_sysv
	rm -rf $linshi_download
	rm -rf "/home/linshi"
	echo "Install v2ray successfully"
}

remove_v2ray(){
	rm -rf $v2ray_config_folder
	rm -rf $v2ray_folder
	rm -rf $v2ray_systemd
	rm -rf $v2ray_sysv
}

check_unzip(){
	unzipcheck=`unzip`
	if [[ -z $unzipcheck ]]; then
		echo -e "your system do not have unzip"
		if [[ $release == "centos" ]]; then
			yum install -y unzip
		else 
			apt-get install -y unzip
		fi
	fi
}

check_vim(){
	vimcheck=`vim --version`
	if [[ -z $vimcheck ]]; then
		echo -e "your system do not have vim"
		if [[ $release == "centos" ]]; then
			yum install -y vim
		else 
			apt-get install -y vim
		fi
	fi
}

check_python(){
	pythoncheck=`python -h`
	if [[ -z $pythoncheck ]]; then
		echo -e "your system do not have python"
		if [[ $release == "centos" ]]; then
			yum install -y python
		else 
			apt-get install -y python
		fi
	fi
}

check_net-tools(){
	nettoolscheck=`ifconfig`
	if [[ -z $nettoolscheck ]]; then
		echo -e "your system do not have net-tools"
		if [[ $release == "centos" ]]; then
			yum install -y net-tools
		else 
			apt-get install -y net-tools
		fi
	fi
}

all_setting(){
	echo "你想干蛤？
	1. 安装v2ray
	2. 删除v2ray
	3. 检查v2ray安装
	4. 检查v2ray控制python脚本
	5. 快速建立一个个人v2ray
	6. 检查v2ray的config
	7. 启动v2ray
	8. 停止v2ray
	9. 重启v2ray
	10. 开启v2ray开机自启动
	11. 关闭v2ray开机自启动
	12. 显示当前设置"
	read -e -p "(默认：取消) " number_v2ray
	if [[ -z $number_v2ray ]]; then
		exitla
	elif [[ $number_v2ray == "1" ]]; then
		#if [[ $releases == "centos" ]]; then
		#	yum update
		#else 
		#	apt-get update
		#fi
		check_sys
		check_unzip
		check_net-tools
		check_vim
		check_python
		install_v2ray
		check_pythoncontrol
	elif [[ $number_v2ray == "2" ]]; then
		v2ray_stop
		remove_v2ray
	elif [[ $number_v2ray == "3" ]]; then
		check_v2rayinstallation
	elif [[ $number_v2ray == "4" ]]; then
		check_pythoncontrol
	elif [[ $number_v2ray == "5" ]]; then
		echo "This action will recover the config file which is /etc/v2ray/config.json"
		echo "If you want to recover the config file, you can type y to continue"
		read -e -p "(默认：取消) " number_fast_user
		if [[ -z $number_fast_user ]]; then
			exitla
		elif [[ $number_fast_user == "y" ]]; then
			rm -rf $v2ray_config
			cd $v2ray_config_folder
			echo "type user here"
			read -e -p "(默认：取消) " user
			echo "type port here"
			read -e -p "(默认：取消) " port
			echo "type inboundprotocol here"
			read -e -p "(默认：取消) " inboundprotocol
			python v2raycp.py -r -u $user -p $port -i $inboundprotocol -g
			v2ray_start
		fi
	elif [[ $number_v2ray == "6" ]]; then
			v2ray_stop
			config_check=`systemctl status v2ray.service | grep "Failed to start V2Ray Service."`
		if [[ -z $config_check ]]; then
			echo "config is perfect, v2ray is going to start"
			v2ray_start
		else
			echo "config is not usable"
		fi
	elif [[ $number_v2ray == "7" ]]; then
		v2ray_start
	elif [[ $number_v2ray == "8" ]]; then
		v2ray_stop
	elif [[ $number_v2ray == "9" ]]; then
		v2ray_restart
		check_v2ray_status
	elif [[ $number_v2ray == "10" ]]; then
		24h_v2ray
	elif [[ $number_v2ray == "11" ]]; then
		24h_v2rayno
	elif [[ $number_v2ray == "12" ]]; then
		show_config
		


	else
		echo "请输入正确的数字"
		exitla
	fi
}
systemctl daemon-reload
check_root
check_v2ray=`find /usr/bin -name v2ray`
if [[ -z  $check_v2ray ]]; then
	echo "there is not v2ray in your system"
else
	check_v2ray_status
fi
all_setting
exitla


