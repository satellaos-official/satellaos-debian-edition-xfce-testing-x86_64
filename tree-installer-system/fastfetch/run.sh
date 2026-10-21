#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

wget https://github.com/satellaos-official/fastfetch/releases/download/fastfetch/fastfetch_2.69.0_x86_64.deb -O /tmp/fastfetch-satellaos.deb

sudo apt install --install-recommends -y /tmp/fastfetch-satellaos.deb

mkdir -p $HOME/.config/fastfetch
cp $SCRIPT_DIR/satellaos.jsonc $HOME/.config/fastfetch/config.jsonc

sudo mkdir -p /etc/skel/.config/fastfetch
sudo cp $SCRIPT_DIR/satellaos.jsonc /etc/skel/.config/fastfetch/config.jsonc

sudo mkdir -p /root/.config/fastfetch
sudo cp $SCRIPT_DIR/satellaos.jsonc /root/.config/fastfetch/config.jsonc
