clear
echo -e "       _ ____
 _ __ (_)___ \ ___
| '_ \| | __) / __|
| |_) | |/ __/ (__
| .__/|_|_____\___|
|_|

Setting up the i2c interface for use....\n"




echo -e "Please enter your root password to allow setup (This will only be for this setup):\n"

stty -echo
read password
stty echo


echo -e "First, lets see if the i2c packages are installed...\n"

dpkg -l 'i2c-tools' > /dev/null 2>&1 
INSTALLED=$?

if [ $INSTALLED == '0' ]; then
        echo -e "i2c-tools are installed...moving on\n"
    else
        echo -e "i2c-tools are not installed...will install now\n"
	sudo apt-get -qq  install 'i2c-tools'
    fi
echo -e "Second, lets check if the smbus python libary is installed....you need this to allow python to hiss over the i2c bus\n"

dpkg -l 'python-smbus' | grep ^ii > /dev/null 2>&1
PY_INSTALLED=$?
if [ $PY_INSTALLED == '0' ]; then
        echo -e "python-smbus libary is installed...nothing to do here\n"
    else
        echo -e "python-smbus libary is not installed...will install now\n"
        sudo apt-get -qq  install 'python-smbus'
    fi

echo -e "Thirdly, Will now check if i2c is disabled on the Pi\n"

if grep -qnx '#blacklist spi-bcm2708' /etc/modprobe.d/raspi-blacklist.conf; then
        echo -e "It looks like i2c is not enabled on this Pi\n Enabling....\n"
        sudo sed -i '/#blacklist spi-bcm2708/c\blacklist spi-bcm2708' /etc/modprobe.d/raspi-blacklist.conf
    else
        echo -e "It looks i2c is enabled on this Pi\n"
    fi

if grep -qE 'i2c-bcm2708|i2c-dev' /etc/modules; then
        echo -e "It looks like the i2c modules are already set to load at boot\n"

    else
        echo -e "It looks like the i2c modules are not set to load at boot.\n Rectifying....\n"
        sudo bash -c "echo "i2c-bcm2708" >> /etc/modules"
        sudo bash -c "echo "i2c-dev" >> /etc/modules"

    fi
echo -e "Now, we check that that any user can access the i2c bus. If you want to restrict this see the readme file\n"

if [ -f /etc/udev/rules.d/99-i2c.rules ];then
    echo -e "Yep, anyone can access the bus...\n"
else
    echo -e "Nope, only Root can use i2c...creating the new rules to change this..\n"
    sudo touch /etc/udev/rules.d/99-i2c.rules
    sudo bash -c "echo 'SUBSYSTEM==\"i2c-dev\", MODE=\"0666\"'>>/etc/udev/rules.d/99-i2c.rules"
fi

echo -e "All done\n"
echo -e "Please reboot me now by typing reboot and pressing enter"

