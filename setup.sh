#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

$SCRIPT_DIR/tree-installer-system/network-manager/run.sh

$SCRIPT_DIR/tree-installer-system/clean-network-interfaces/run.sh

$SCRIPT_DIR/tree-installer-system/core/run.sh

$SCRIPT_DIR/tree-installer-system/update-sources.list/run.sh

$SCRIPT_DIR/tree-installer-system/update-adduser/run.sh

$SCRIPT_DIR/tree-installer-system/hide-kernel-messages/run.sh

$SCRIPT_DIR/tree-installer-system/flatpak-installer/run.sh

$SCRIPT_DIR/tree-installer-system/grub-settings/run.sh

$SCRIPT_DIR/tree-installer-system/grub-theme/run.sh

# $SCRIPT_DIR/tree-installer-system/lightdm-settings/run.sh

$SCRIPT_DIR/tree-installer-system/pictures/run.sh

$SCRIPT_DIR/tree-installer-system/themes/run.sh

$SCRIPT_DIR/tree-installer-system/update-os-release/run.sh

$SCRIPT_DIR/tree-installer-system/xfce-interface/run.sh

$SCRIPT_DIR/tree-installer-system/font-installer/run.sh

$SCRIPT_DIR/tree-installer-system/fastfetch/run.sh
