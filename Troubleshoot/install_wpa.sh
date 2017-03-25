#!/bin/bash

#clear

#Title :Pera wifi Troubleshoot fixer !
#Author: Namila Bandara
#github link: https://github.com/namila007/Pera_WiFi_Fixer

if [ "$(whoami)" != "root" ]; then
	echo -en "\033[1B"
	echo -e "  \e[38;5;160m$USER!!\e[38;5;100m Please run in sudo mode"
	echo -e "  \e[38;5;42mtype \e[38;5;190msudo $0 --help\e[0;0m"
	exit 1
fi 

set_dl(){
echo "deb http://london.mirrors.linode.com/ubuntu/ vivid main" | sudo tee /etc/apt/sources.list.d/vivid.list
echo -e "Package: *\nPin: release o=Ubuntu,n=vivid\nPin-Priority: -1" | sudo tee cat /etc/apt/preferences.d/vivid
}

update(){
sudo apt-get update
sudo apt-get install wpasupplicant=2.1-0ubuntu7
sudo apt-mark hold 
}

error_update(){
	sudo apt-get install -f wpasupplicant=2.1-0ubuntu7
	sudo apt-mark hold 
}

restart(){
sudo /etc/init.d/network-manager restart
}



#update
if [[ $1 = "-h" ]] || [[ $1 = "--help" ]] ; then
	echo -en "\e[38;5;41mAvalable options:\n"
	echo -en "\e[17C\e[38;5;42m -wpa \e[0;0m:For installation of WPASupplicant\n"
	echo -en "\e[17C\e[38;5;42m -cl  \e[0;0m:For clear system certificates\n"
	echo -en "\e[2C\e[38;5;160mexample : sudo $0 -OPTION\n\e[0;0m"
	exit 1
	
elif [[ $1 = "-wpa" ]] ; then
		set_dl
		update 
	if [ $(dpkg-query -W -f='${Status}' wpasupplicant 2>/dev/null | grep -c "ok installed") = 1 ] ; then
		
		restart
		echo -e "\e[38;5;42mJOB DONE!!!"
		exit 1
	else 
		error_update
		
		if [ $(dpkg-query -W -f='${Status}' wpasupplicant 2>/dev/null | grep -c "ok installed") = 1 ] ; then
			echo -e "\e[38;5;42mJOB DONE!!!\e[0;0m"
			exit 1
		else
			echo -e "\e[38;5;160mInstallation failed.Please run again\e[0;0m"	
			exit 1

		fi	
	fi
elif [[ $1 = "-cl" ]] ; then


	
	
	if [ ! -f /etc/NetworkManager/system-connections/Pera\ WiFi ]; then
    echo -e "\e[38;5;160mFile not found!\e[0;0m"
    exit 1
	fi
	$filename="/etc/NetworkManager/system-connections/Pera\ WiFi"
	sed -i.bak 's/system-ca-certs=true/system-ca-certs=false/' $filename 
	if ! diff $filename $filename.bak &> /dev/null; then
		echo -e "\e[38;5;160mFile Edited and Backup is created $filename.bak \e[0;0m"
	else
		echo -e "\e[38;5;160m  no '$changefrom' found \e[0;0m"
	fi	
	exit 1

elif [[ $1 = "" ]] ; then
	echo -e "\e[2C\e[38;5;160mENTER OPTION TO RUN\e[0;0m"
	echo -e "\e[2CFor help use \e[38;5;41m --help or -h \e[0;0m"
	echo -e "\e[2C\e[38;5;42mexample : sudo $0 -help\e[0;0m"
	exit 1		
fi
