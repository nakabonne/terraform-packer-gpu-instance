#!/bin/bash

set -e

sudo apt install -y ubuntu-drivers-common alsa-base

sudo ubuntu-drivers install
sudo reboot
