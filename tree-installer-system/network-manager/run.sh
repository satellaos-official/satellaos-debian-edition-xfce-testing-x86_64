#!/bin/bash

echo "installing network manager"

sudo apt update
sudo apt upgrade -y

sudo apt install --no-install-recommends -y network-manager network-manager-applet wpasupplicant

echo "Enabling Network Manager"
