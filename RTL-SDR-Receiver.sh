#!/bin/bash

rtl_sdr -s 1.8e6 -f 55992300 -p 1500 -g 20  - | play -r 48000 -t s16 -L -c 1  -

##########################################################################
#qtcsdr makes a ham transceiver out of your Raspberry Pi 2 and RTL-SDR!
#https://github.com/ha7ilm/qtcsdr

#Uage:
#git clone https://github.com/ha7ilm/qtcsdr
#cd qtcsdr
#./rpi-install.sh be careful to use "sudo",or make starigt question
#./rpi-test.sh

#I want to run stl_sdr receiver withou GUI to acclalte
#Why this script run to writing err when choose "y"or "no"
#我想直接用libcsdr直接输出音频，减少资源利用
#不到为什么进行if选择的时候，提示脚本语法错误
###########################################################################
echo "This is the qtcsdr install script for Raspbian Jessie."
read -r -p "It will install qtcsdr along with all of its dependencies. Are you sure? [y/n] " response
if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]
then
	echo "Installing deps..."
else
	echo "Aborted."
	exit 0
fi

REBOOT_LATER=0

mkdir deps
cd deps

echo
echo "Installing packages..."
sudo apt-get update
sudo apt-get install nmap qt5-default qt5-qmake git libfftw3-dev cmake libusb-1.0-0-dev 
if [ $? -ne 0 ]; then
	echo "Installing package dependencies failed, please resolve it manually."
	exit 1
fi

echo
echo "Installing pgroup..."
git clone https://github.com/ha7ilm/pgroup
cd pgroup
make && sudo make install
cd ..

echo
read -r -p "Can I install rpitx? (Enter N to skip.) [y/n] " response
if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]
then
	git clone https://github.com/ha7ilm/rpitx.git
	cd rpitx
	bash install.sh	
	if [ $? -ne 0 ]; then
		echo "Installing rpitx failed, please resolve it manually."
		exit 1
	fi
	cd ..
fi

echo
read -r -p "Can I install the latest dev branch of csdr? (Enter N to skip.) [y/n] " response
if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]
then
	echo "Installing the dev branch of csdr..." 
	git clone https://github.com/simonyiszk/csdr.git
	cd csdr
	git fetch
	git checkout dev
	make && sudo make install
	if [ $? -ne 0 ]; then
		echo "Installing csdr failed, please resolve it manually."
		exit 1
	fi
	cd ..
fi

echo
read -r -p "Can I install rtl-sdr from keenerd's repo? (Enter N to skip.) [y/n] " response
if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]
then
	git clone https://github.com/keenerd/rtl-sdr
	cd rtl-sdr/ && mkdir build && cd build
	cmake ../ -DINSTALL_UDEV_RULES=ON
	make && sudo make install && sudo ldconfig
	if [ $? -ne 0 ]; then
		echo "Installing rtl-sdr failed, please resolve it manually."
		exit 1
	fi
	cd ../..

	echo
	read -r -p "Should I blacklist the dvb_usb_rtl28xxu kernel module in order to be able to use rtl-sdr? (Enter N to skip.) [y/n] " response
	if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]
	then
		sudo bash -c 'echo -e "\n# for RTL-SDR:\nblacklist dvb_usb_rtl28xxu\n" >> /etc/modprobe.d/blacklist.conf'
		echo
		REBOOT_LATER=1
		echo "Note: You will have to reboot before running qtcsdr!"		
		echo
	fi
fi

echo
echo "Now I'm building qtcsdr..."
cd ..
mkdir build
cd build
qmake ..
make -j4
sudo install -m 0755 qtcsdr /usr/bin

echo
echo "We're ready."
if [ $REBOOT_LATER -eq 1 ]; then
	echo "You should reboot your Pi, then run \"rpi-test.sh\" in the qtcsdr directory."
else
	echo "If there were no errors, you can now proceed to running \"rpi-test.sh\"."
fi
