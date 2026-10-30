#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# User config
mkdir -p "$HOME/.config"
cp -aT "$SCRIPT_DIR/user/.config/" "$HOME/.config/"

# /etc/skel
sudo mkdir -p /etc/skel/.config
sudo cp -aT "$SCRIPT_DIR/user/.config/" /etc/skel/.config/

# Root config
sudo mkdir -p /root/.config
sudo cp -aT "$SCRIPT_DIR/root/.config/" /root/.config/

# LightDM
sudo mkdir -p /etc/lightdm
sudo cp -aT "$SCRIPT_DIR/lightdm/" /etc/lightdm/