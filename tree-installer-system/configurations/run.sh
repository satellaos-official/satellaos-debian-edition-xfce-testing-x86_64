#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# User config
mkdir -p "$HOME/.config"
cp -aT "$SCRIPT_DIR/user/.config/" "$HOME/.config/"
cp $SCRIPT_DIR/user/.bashrc $HOME/.bashrc

# /etc/skel
sudo mkdir -p /etc/skel/.config
sudo cp -aT "$SCRIPT_DIR/user/.config/" /etc/skel/.config/
sudo cp $SCRIPT_DIR/user/.bashrc /etc/skel/.bashrc

# Root config
sudo mkdir -p /root/.config
sudo cp -aT "$SCRIPT_DIR/root/.config/" /root/.config/
sudo cp $SCRIPT_DIR/root/.bashrc /root/.bashrc

# LightDM
sudo mkdir -p /etc/lightdm
sudo cp -aT "$SCRIPT_DIR/lightdm/" /etc/lightdm/