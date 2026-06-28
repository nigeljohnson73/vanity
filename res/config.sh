#!/usr/bin/bash

sudo mkdir -p /logs
sudo chown -R pi:pi /logs
sudo chmod 777 /logs
export logfile=/logs/install.log
echo "" >$logfile

# Error management - fail on first error
set -o errexit
set -o pipefail
#set -o nounset

# get current directory

root=`realpath $0`
root=`dirname $root`
root=`realpath $root/..`
echo "Working directory: $root"
cd $root

echo "## Update BIOS and core OS" | tee -a $logfile
sudo apt update -y
sudo apt full-upgrade -y
sudo apt autoremove -y
sudo rpi-eeprom-update -a -d ### SHoud we do this pi 3 ?????
sudo apt install -y python3-dev python3-pip python3-setuptools python3-wheel tor nginx xxd i2pd gcc libc6-dev libsodium-dev make autoconf libboost-dev libssl-dev

echo "" | tee -a $logfile
if [ -d ".venv" ]; then
	echo "## Python environment already configured" | tee -a $logfile
else
	echo "## Configure python environment" | tee -a $logfile
	python -m venv .venv
	. .venv/bin/activate
	if [ -f "requirements.txt" ]; then
		pip install -r requirements.txt
	fi
fi

echo "" | tee -a $logfile
echo "## Install bashrc hooks" | tee -a $logfile
# Change the relative path at the top of the login script
sed -i.bak "/RPATH=/c\RPATH=$root #XRUNPATH" $root/res/bashrc
# ensure python env points into this project
sed -i.bak "/ENABLEPROJECT/d" ~/.bashrc
echo "source $root/res/bashrc #ENABLEPROJECT" >> ~/.bashrc

echo "" | tee -a $logfile
echo "## Setting up bash_profile" | tee -a $logfile
bash -c 'cat > ~/.bash_profile' <<EOF
if [ -f ~/.bashrc ]; then
        . ~/.bashrc
fi
EOF

echo "" | tee -a $logfile
echo "## Compiling pistat binaries" | tee -a $logfile
cc res/pistat.c -lm -o sh/pistat

echo "" | tee -a $logfile
echo "## Building I2P toolchain" | tee -a $logfile
if [ -d i2pd-tools ]; then
	echo "Repository exists"
else
	git clone --recursive https://github.com/purplei2p/i2pd-tools
fi
cd i2pd-tools
bash dependencies.sh
make
cp vain ../sh/vanity_i2p
cd ..

echo "" | tee -a $logfile
echo "## Building TOR toolchain" | tee -a $logfile
if [ -d mkp224o ]; then
	echo "Repository exists"
else
	git clone https://github.com/cathugger/mkp224o.git
fi
cd mkp224o
./autogen.sh
./configure
make
cp mkp224o ../sh/vanity_tor
cd ..

echo "####################################################################" | tee -a $logfile
echo "" | tee -a $logfile
echo "A summary of this install can be foung in $logfile" | tee -a $logfile
echo "" | tee -a $logfile
echo "We are all done. Thanks for flying with us today and we value your" | tee -a $logfile
echo "custom as we know you have choices. The next steps for you are:" | tee -a $logfile
echo "" | tee -a $logfile
echo " * Add the following entries to your crontab" | tee -a $logfile
echo "     @reboot $root/sh/vanityctl start all" | tee -a $logfile
echo "     3 6,14,20 * * * $root/sh/keystat.sh" | tee -a $logfile
echo " * Reboot this raspberry pi" | tee -a $logfile
echo " * run $root/sh/keyfind.sh <yourkey>" | tee -a $logfile
echo "" | tee -a $logfile
echo "####################################################################" | tee -a $logfile

