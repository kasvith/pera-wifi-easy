#!/bin/bash

#clear

if [ "$(whoami)" != "root" ]; then
	echo -en "\033[1B"
	echo "  $USER!! Please run in sudo mode"
	echo "  type sudo ./install_wpa.sh"
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

restart(){
sudo /etc/init.d/network-manager restart
}


set_dl
#update
if [dpkg -s wpasupplicant ==1 ] ; then
	restart
	echo "JOB DONE!!"
	exit 1
else 
	echo "run again"
fi		
