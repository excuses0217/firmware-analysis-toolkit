#!/bin/sh

set -e
sudo apt update
sudo apt install -y python3-pip python3-pexpect unzip busybox-static fakeroot kpartx snmp uml-utilities util-linux vlan qemu-system-arm qemu-system-mips qemu-system-x86 qemu-utils wget tar

if [ ! -x "$(which lsb_release)" ]
then
    sudo apt install -y lsb-core
fi

echo "Installing firmadyne"
cd firmadyne
firmadyne_dir=$(realpath .)

# Set FIRMWARE_DIR in firmadyne.config
sed -i "/FIRMWARE_DIR=/c\FIRMWARE_DIR=$firmadyne_dir" firmadyne.config

# Comment out psql -d firmware ... in getArch.sh
sed -i 's/psql/#psql/' ./scripts/getArch.sh

# Change interpreter to python3
sed -i 's/env python/env python3/' ./sources/extractor/extractor.py ./scripts/makeNetwork.py
cd ..

echo "Setting up firmware analysis toolkit"
chmod +x fat.py
chmod +x reset.py

# Set firmadyne_path in fat.config
sed -i "/firmadyne_path=/c\firmadyne_path=$firmadyne_dir" fat.config

cd qemu-builds

unzip -qq qemu-system-static-2.0.0.zip && rm qemu-system-static-2.0.0.zip

unzip -qq qemu-system-static-2.5.0.zip && rm qemu-system-static-2.5.0.zip

tar xf qemu-system-static-3.0.0.tar.gz && rm qemu-system-static-3.0.0.tar.gz

cd ..

echo "====================================================="
echo "Firmware Analysis Toolkit installed successfully!"
echo "Before running fat.py for the first time,"
echo "please edit fat.config and provide your sudo password"
echo "====================================================="
