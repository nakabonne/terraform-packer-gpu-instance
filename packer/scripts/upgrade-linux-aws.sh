#!/bin/bash

set -e

sudo apt update -y
sudo apt upgrade -y linux-aws
# Reboot to load the latest kernel
sudo reboot
