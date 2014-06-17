pi2c - i2c setup on the raspberry pi version 0.1
copyright 2014 Michael Rimicans @heeedt


This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.



       _ ____
 _ __ (_)___ \ ___
| '_ \| | __) / __|
| |_) | |/ __/ (__
| .__/|_|_____\___|
|_|...........LOCAL

Setting up the i2c interface for use on the Raspberry Pi....

Note: This is an offline installer - It will require that

	i2c-tools_3.1.0-2_armhf.deb
	
	python-smbus_3.1.0-2_armhf.deb

....are already downloaded into ./local and ready for use
##############################################################

To download the required packages use the following commands:

	sudo apt-get download python-smbus
	
	sudo apt-get download i2c-tools

#############################################################
version 0.2


Hello

This script will help you to set up i2c connectivity on the Raspberry Pi.

As posted by Simon Walters (@cymplecy):

"  Youngsters are coming along and using my ScratchGPIO to control stuff liek the PiGlow but this needs I2C enabling.

Recanatha has instructions http://www.recantha.co.uk/blog/?p=2582
but we could really do with a nice little script to automate the process

Any takers?

Simon  "

( http://www.raspberrypi.org/forum/viewtopic.php?f=29&t=65172 )


I volunteered...


Usage:

	1: Make it executable:
		
		chmod +x pi2c_local.sh

	2: Run it:

		./pi2c_local.sh

	3: Make things :)


notes:

If you would like to restrict i2c access to a specific group then the following
instructions will need to be followed:

	1: Open /etc/udev/rules.d/99-i2c.rules in a text editor

	2: Locate SUBSYSTEM=="i2c-dev", MODE="0666"

	3: Change to SUBSYSTEM=="i2c-dev", GROUP="<insert group name here>", MODE="0666"


@heeedt




