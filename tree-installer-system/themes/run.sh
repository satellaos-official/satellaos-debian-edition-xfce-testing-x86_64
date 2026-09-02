#!/bin/bash

# Dependencies
sudo apt install --install-recommends -y adwaita-qt gnome-themes-extra

# GTK Theme
git clone --depth 1 https://github.com/satellaos-official/layan-all-colors.git "/tmp/layan-all-colors"
sudo bash /tmp/layan-all-colors/install.sh -s

# Icon Theme
git clone --depth 1 https://github.com/vinceliuice/Tela-icon-theme.git "/tmp/Tela-icon-theme"
sudo bash /tmp/Tela-icon-theme/install.sh -a -d /usr/share/themes
rm -rf "/tmp/Tela-icon-theme"

# Curcor Theme
git clone --depth 1 https://github.com/satellaos-official/volantes-cursors-compiled.git "/tmp/volantes-cursors-compiled"
sudo bash /tmp/volantes-cursors-compiled/install.sh -s
