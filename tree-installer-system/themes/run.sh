#!/bin/bash

# Dependencies
sudo apt install --install-recommends -y adwaita-qt gnome-themes-extra

# GTK Theme
git clone --depth 1 https://github.com/satellaos-official/Layan-gtk-theme-all-color.git "/tmp/Layan-gtk-theme-all-color"
sudo bash /tmp/Layan-gtk-theme-all-color/install.sh -s
rm -rf "/tmp/Layan-gtk-theme-all-color"

# Icon Theme
git clone --depth 1 https://github.com/satellaos-official/tela-icon-theme-fixed.git "/tmp/tela-icon-theme-fixed"
sudo bash /tmp/tela-icon-theme-fixed/install.sh -a -d /usr/share/icons
rm -rf "/tmp/tela-icon-theme-fixed"

# Curcor Theme
git clone --depth 1 https://github.com/satellaos-official/volantes-cursors-compiled.git "/tmp/volantes-cursors-compiled"
sudo bash /tmp/volantes-cursors-compiled/install.sh -s
