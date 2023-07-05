# INSTALLING OTBR stack 
## These steps need to be performed on RPi.
So install Ubuntu 22.04 or 23.04 on RPi and then copy install-otbr.sh on rpi and execute it as given below

```
chmod +x install-otbr.sh
./install-otbr.sh wlan0

```

The whole process is also mentioned here,
[installing-otbr-manually-raspberry-pi](https://developer.nordicsemi.com/nRF_Connect_SDK/doc/latest/nrf/protocols/thread/tools.html#installing-otbr-manually-raspberry-pi)

**It is recommended to reboot the RPi once above steps are finished.**

# Programming the nRF52840 Dongles
**Note-: This Process can be done on normal PC**

## INSTALLING nRF Connect SDK  

**This is totally optional if you are only going to program nRF dongles**


 1. To code/debug & program Thread modules(nrf52840 dongles) installation of nRF connect SDK is essential.
 2. There are two ways to do it.
     1. Automatic installation.
     2. Manual installation.

**Let us proceed with automatic installation by following the link**

[nRF connect SDK installation](https://developer.nordicsemi.com/nRF_Connect_SDK/doc/latest/nrf/getting_started/assistant.html#gs-assistant)

Once the installation is complete then follow the above link for command line based workflow for building and programming applications into nrf dongles.
This will launch the terminal from where one can access nRF SDK commands.

## INSTALL THE TOOLS USED FOR PROGRAMMING THE DONGLE
The detailed instructions are given here 
https://infocenter.nordicsemi.com/index.jsp?topic=%2Fug_nrfutil%2FUG%2Fnrfutil%2Fnrfutil_installing.html

 1. But in short, just get the archive from this repo ```x86_tools.tar.gz``` and execute following commands,

```
tar -zxf x86_tools.tar.gz
sudo dpkg -i x86_tools/nrf-command-line-tools_10.21.0_amd64.deb
#please follow the instriuctions as printed on the terminal
sudo cp nrfutil /usr/local/bin/

```
***Note-:The details about the nRF52840 dongle are given here.***
[nRF52840 dongle details](https://developer.nordicsemi.com/nRF_Connect_SDK/doc/latest/zephyr/boards/arm/nrf52840dongle_nrf52840/doc/index.html#nrf52840dongle-nrf52840)
## Flashing the Dongles
### Preparation of RCP(Radio Coprocessor) Dongle
1. Connect the nrf52840 dongle to usb port. Extract the archive ``` otbr-rcp-firmware.tar.gz ```
2. Reset the dongle by pushing in the reset switch, ensure that Red LED start fading smoothly.
3. Then use the following command to program the dongle
```
nrfutil dfu usb-serial -pkg otbr-rcp-firmware/zephyr.zip -p /dev/ttyACM0

```
**NOTE-:**
If someone wants to compile otbr firmware for nrf52840 dongle it can be done as mentioned here
[Thread Radio Coprocessor programming](https://developer.nordicsemi.com/nrf_connect_sdk/doc/latest/nrf/protocols/thread/tools.html#configuring-a-radio-co-processor)
or simply executing following command from nrf sdk terminal window which can be launched as explained above
```
west build -p always -b nrf52840dongle_nrf52840 nrf/samples/openthread/coprocessor/ -- -doverlay_config="overlay-usb.conf" -ddtc_overlay_file="usb.overlay"
```
#### Checking Dongle is programmed or not

1. Once thread module(dongle) is programmed  then insert the module into RPi usb port
    and then give the command
```     
systemctl restart otbr-agent

```
2. check the status of otbr-agent daemon, it should be active and running
```
systemctl status otbr-agent

```
## TO FORM A THREAD NETWORK WITH OTBR execute following commands on RPi
```
sudo ot-ctl dataset init new
sudo ot-ctl dataset commit active
sudo ot-ctl ifconfig up
sudo ot-ctl thread start
sleep 5
sudo ot-ctl state
sudo ot-ctl netdata show
sudo ot-ctl ipaddr
```
***Note-:All the  above steps are well explained at***
[creating/initializing thread Network](https://openthread.io/codelabs/openthread-border-router#2)


### PROGRAMMING THE SECOND NRF52840 DONGLE TO ACT AS MATTER LIGHTING BULB OVER THREAD 
 1. Connect the dongle to usb port.
 2. Extract the archive nrf52840dongle-lighting-app.tar
 3. Reset the dongle by pushing in the reset switch, ensure that Red LED start fading smoothly.
 4. Use the following command to program the dongle.
 
```
nrfutil dfu usb-serial -pkg nrf52840dongle-lighting-app/merged.zip -p /dev/ttyACM0
```

## TO PLAY WITH DONGLE
https://github.com/project-chip/connectedhomeip/blob/master/docs/guides/chip_tool_guide.md
1. Connect nRF52840 dongle programmed as RCP to RPi
2. Connect second nRF52840 dongle to 
3. Get the thread network credentials.

```
sudo ot-ctl dataset active -x

```
3. Get the credentials printed by above command use in the below command. Use the chip-tool executable from this repo

```
./chip-tool pairing ble-thread <nodeid> hex:<thread NW creds> 20202021 3840
```
4. Once the pairing is successful
```
./chip-tool onoff toggle  <nodeid> <endpoint> 
```
