#!/bin/bash

# Dependencies
sudo apt install --install-recommends -y adwaita-qt gnome-themes-extra

# GTK Theme
git clone --depth 1

# Icon Theme
git clone --depth 1 https://github.com/vinceliuice/Tela-icon-theme.git "/tmp/Tela-icon-theme"
sudo bash /tmp/Tela-icon-theme/install.sh -a -d /usr/share/themes
rm -rf "/tmp/Tela-icon-theme"
