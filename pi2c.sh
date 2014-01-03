#!/bin/bash

#pi2c - i2c setup on the raspberry pi version 0.1
#copyright 2014 @heeedt

#This program is free software: you can redistribute it and/or modify
#it under the terms of the GNU General Public License as published by
#the Free Software Foundation, either version 3 of the License, or
#(at your option) any later version.

#This program is distributed in the hope that it will be useful,
#but WITHOUT ANY WARRANTY; without even the implied warranty of
#MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#GNU General Public License for more details.

#You should have received a copy of the GNU General Public License
#along with this program.  If not, see <http://www.gnu.org/licenses/>.



GREEN='\e[00;32m'
DEFT='\e[00m'
RED='\e[00;31m'
YELLOW='\e[00;33m'
clear
echo -e "${YELLOW}       _ ____
 _ __ (_)___ \ ___
| '_ \| | __) / __|
| |_) | |/ __/ (__
| .__/|_|_____\___|
|_|

Setting up the i2c interface for use on the Raspberry Pi....\n
##############################################################\n"


echo -e "${DEFT}Please enter your root password to allow setup (This will only be for this setup):\n"

stty -echo
read password
stty echo


echo -e "First, lets see if the i2c packages are installed...\n"

dpkg -l 'i2c-tools' > /dev/null 2>&1 
INSTALLED=$?

if [ $INSTALLED == '0' ]; then
        echo -e "${GREEN}i2c-tools are installed...moving on\n"
    else
        echo -e "${RED}i2c-tools are not installed...will install now\n"
	sudo apt-get -qq  install 'i2c-tools'
    fi
echo -e "${DEFT}Second, lets check if the smbus python libary is installed....you need this to allow python to hiss over the i2c bus:\n"

dpkg -l 'python-smbus' | grep ^ii > /dev/null 2>&1
PY_INSTALLED=$?
if [ $PY_INSTALLED == '0' ]; then
        echo -e "${GREEN}python-smbus libary is installed...nothing to do here\n"
    else
        echo -e "${RED}python-smbus libary is not installed...will install now\n"
        sudo apt-get -qq  install 'python-smbus'
    fi

echo -e "${DEFT}Thirdly, Will now check if i2c is disabled on the Pi:\n"

if grep -qnx '#blacklist spi-bcm2708' /etc/modprobe.d/raspi-blacklist.conf; then
        echo -e "${RED}It looks like i2c is not enabled on this Pi\n Enabling....\n"
        sudo sed -i '/#blacklist spi-bcm2708/c\blacklist spi-bcm2708' /etc/modprobe.d/raspi-blacklist.conf
    else
        echo -e "${GREEN}It looks i2c is enabled on this Pi\n"
    fi

echo -e "${DEFT}Is i2c set to load on boot?:\n"

if grep -qE 'i2c-bcm2708|i2c-dev' /etc/modules; then
        echo -e "${GREEN}It looks like the i2c modules are already set to load at boot\n"

    else
        echo -e "${RED}It looks like the i2c modules are not set to load at boot.\n Rectifying....\n"
        sudo bash -c "echo "i2c-bcm2708" >> /etc/modules"
        sudo bash -c "echo "i2c-dev" >> /etc/modules"

    fi
echo -e "${DEFT}Now, we check that that any user can access the i2c bus. If you want to restrict this see the readme file:\n"

if [ -f /etc/udev/rules.d/99-i2c.rules ];then
    echo -e "${GREEN}Yep, anyone can access the bus...\n"
else
    echo -e "${RED}Nope, only Root can use i2c...creating the new rules to change this..\n"
    sudo touch /etc/udev/rules.d/99-i2c.rules
    sudo bash -c "echo 'SUBSYSTEM==\"i2c-dev\", MODE=\"0666\"'>>/etc/udev/rules.d/99-i2c.rules"
fi

echo -e "${DEFT}All done\n"
echo -e "Please reboot me now by typing reboot and pressing enter"

