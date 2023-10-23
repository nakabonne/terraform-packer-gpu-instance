#!/bin/bash

set -e

sudo apt-get install -y gcc make linux-headers-$(uname -r)

# Disable the nouveau open source driver for NVIDIA graphics cards.
cat << EOF | sudo tee --append /etc/modprobe.d/blacklist.conf
blacklist vga16fb
blacklist nouveau
blacklist rivafb
blacklist nvidiafb
blacklist rivatv
EOF

sudo echo GRUB_CMDLINE_LINUX="rdblacklist=nouveau" >> /etc/default/grub
sudo update-grub

# Downlad driver
aws s3 cp --recursive s3://ec2-linux-nvidia-drivers/latest/ .
chmod +x NVIDIA-Linux-x86_64*.run

# Install driver
sudo /bin/sh ./NVIDIA-Linux-x86_64*.run

sudo touch /etc/modprobe.d/nvidia.conf
echo "options nvidia NVreg_EnableGpuFirmware=0" | sudo tee --append /etc/modprobe.d/nvidia.conf
sudo reboot
