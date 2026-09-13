#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# User

cp $SCRIPT_DIR/.config/* $HOME/.config/

cp $SCRIPT_DIR/.wallpaper/user/xfce4-desktop.xml $HOME/.config/xfce4-desktop.xml

cp $SCRIPT_DIR/.bashrc* $HOME/.bashrc

# /etc/skel

sudo cp $SCRIPT_DIR/.config/* /etc/skel/.config/

sudo cp $SCRIPT_DIR/.wallpaper/user/xfce4-desktop.xml /etc/skel/.config/xfce4-desktop.xml

sudo cp $SCRIPT_DIR/.bashrc* /etc/skel/.bashrc

# Root

sudo cp $SCRIPT_DIR/.config/* /root/.config/

sudo cp $SCRIPT_DIR/.wallpaper/root/xfce4-desktop.xml /root/.config/xfce4-desktop.xml

sudo cp $SCRIPT_DIR/.bashrc* /root/.bashrc
