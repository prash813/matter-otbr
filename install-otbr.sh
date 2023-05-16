#!/bin/sh
if [ $# -lt 1 ] then
	echo "Usage:: $0 <wifi interface name like wlan0 on RPi>"
	return
fi	
git clone https://github.com/openthread/ot-br-posix.git --depth 1
##steps which are important for nRF dongle to run correctly with OTBR
cd ot-br-posix
git pull --unshallow
git checkout a892bf7
sync
./script/bootstrap
sync
INFRA_IF_NAME=$1 ./script/setup
sudo cp otbr-agent /etc/default/

