# INSTALLING OTBR stack 
## These steps need to be performed on RPi
```
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

```

The whole process is also mentioned here,
[nstalling-otbr-manually-raspberry-pi](https://developer.nordicsemi.com/nRF_Connect_SDK/doc/latest/nrf/protocols/thread/tools.html#installing-otbr-manually-raspberry-pi)


#It is recommended to reboot the RPi once above steps are finished.

### INSTALLING nRF Connect SDK 

##This is totally optional

# This Process can be done on normal PC 
#To program thread module installation of nRF connect SDK is essential. There are two ways to do it.
#automatic installation
#manual installation
#let us proceed with automatic installation by following link

# https://developer.nordicsemi.com/nRF_Connect_SDK/doc/latest/nrf/getting_started/assistant.html#gs-assistant
# Once the installation is complete then follow the above link for command line based build which will launch terminal


### INSTALL THE TOOLS USED FOR PROGRAMMING THE DONGLE
#The detailed instructions are given here 
## https://infocenter.nordicsemi.com/index.jsp?topic=%2Fug_nrfutil%2FUG%2Fnrfutil%2Fnrfutil_installing.html

# 1. But in short install the debian package 

sudo dpkg -i nrf-command-line-tools_10.21.0_amd64.deb

# 2. Please follow the instructions as printed on the terminal

# 3. Download the util nrfutil https://developer.nordicsemi.com/.pc-tools/nrfutil/x64-linux/nrfutil
# 4. copy the downloaded file to the path as generated during "nRF Connect SDK" installation above

cp nrfutil <home dir>/ncs/toolchains/v2.3.0/usr/local/bin/


#The details about the dongle are given here.

# https://developer.nordicsemi.com/nRF_Connect_SDK/doc/latest/zephyr/boards/arm/nrf52840dongle_nrf52840/doc/index.html#nrf52840dongle-nrf52840

#connect the nrf52840 dongle to usb port. extract the archive otbr-rcp-firmware.tar
#reset the dongle till red LED start fading smoothly.
#then use the following command to program the dongle

nrfutil dfu usb-serial -pkg otbr-rcp-firmware/zephyr.zip -p /dev/ttyACM0

##NOTE-:
#if someone wants to compile otbr firmware for nrf 52840 dongle it can be done as mentioned here
#https://developer.nordicsemi.com/nrf_connect_sdk/doc/latest/nrf/protocols/thread/tools.html#configuring-a-radio-co-processor
# or simply executing following steps from nrf sdk terminal window which can be launched as explained above

west build -p always -b nrf52840dongle_nrf52840 nrf/samples/openthread/coprocessor/ -- -doverlay_config="overlay-usb.conf" -ddtc_overlay_file="usb.overlay"


# once  thread module is programmed  then insert the module into rpi usb port
# and then give the command
systemctl restart otbr-agent

#check the status of otbr-agent daemon, it should be active and running
systemctl status otbr-agent


# TO FORM A THREAD NETWORK WITH OTBR follow the script on RPi

sudo ot-ctl dataset init new
sudo ot-ctl dataset commit active
sudo ot-ctl ifconfig up
sudo ot-ctl thread start
sleep 5
sudo ot-ctl state
sudo ot-ctl netdata show
sudo ot-ctl ipaddr

#All the  above steps are well explained at
# https://openthread.io/codelabs/openthread-border-router#2


##PROGRAMMING THE SECOND NRF52840 DONGLE TO ACT AS MATTER LIGHTING BULB OVER THREAD 
# 1. Connect the dongle to usb port.
# 2.extract the archive nrf52840dongle-lighting-app.tar
# 3. Reset the dongle till red LED start fading smoothly.

# 4. then use the following command to program the dongle

nrfutil dfu usb-serial -pkg nrf52840dongle-lighting-app/merged.zip -p /dev/ttyACM0


## TO PLAY WITH DONGLE
https://github.com/project-chip/connectedhomeip/blob/master/docs/guides/chip_tool_guide.md
1. get the thread network credentials

