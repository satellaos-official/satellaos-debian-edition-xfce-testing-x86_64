#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# User
mkdir -p "$HOME/.config"
cp -r "$SCRIPT_DIR"/.config/* "$HOME/.config/"
mkdir -p "$HOME/.config/xfce4/xfconf/xfce-perchannel-xml"
cp "$SCRIPT_DIR/.wallpaper/user/xfce4-desktop.xml" "$HOME/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-desktop.xml"
cp "$SCRIPT_DIR"/.bashrc* "$HOME/.bashrc"

# /etc/skel
sudo mkdir -p /etc/skel/.config
sudo cp -r "$SCRIPT_DIR"/.config/* /etc/skel/.config/
sudo mkdir -p /etc/skel/.config/xfce4/xfconf/xfce-perchannel-xml
sudo cp "$SCRIPT_DIR/.wallpaper/user/xfce4-desktop.xml" /etc/skel/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-desktop.xml
sudo cp "$SCRIPT_DIR"/.bashrc* /etc/skel/.bashrc

# Root
sudo mkdir -p /root/.config
sudo cp -r "$SCRIPT_DIR"/.config/* /root/.config/
sudo mkdir -p /root/.config/xfce4/xfconf/xfce-perchannel-xml
sudo cp "$SCRIPT_DIR/.wallpaper/root/xfce4-desktop.xml" /root/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-desktop.xml
sudo cp "$SCRIPT_DIR"/.bashrc* /root/.bashrc
