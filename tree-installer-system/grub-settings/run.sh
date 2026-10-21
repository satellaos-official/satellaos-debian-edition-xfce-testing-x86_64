#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

sudo cp $SCRIPT_DIR/grub /etc/default/grub
sudo update-grub
sudo update-initramfs -u
