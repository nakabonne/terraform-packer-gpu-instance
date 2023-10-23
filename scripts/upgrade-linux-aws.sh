#!/bin/bash

set -e

sudo apt-get update -y
sudo apt-get upgrade -y linux-aws
# Reboot to load the latest kernel
sudo reboot
