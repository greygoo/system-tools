#!/bin/sh

WD=$(pwd)
trap "cd ${WD}" INT TERM
cd /tmp

echo "Cloning latest system intaller"
rm -rf system-installer
git clone https://github.com/greygoo/system-installer.git 

echo "Updating OS"
yes | DEBIAN_FRONTEND=noninteractive apt-get -yqq update
yes | DEBIAN_FRONTEND=noninteractive apt-get -yqq upgrade

echo "Updating 3rd party apps"
cd system-installer
./install.sh

cd ${WD}
