#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

bash $SCRIPT_DIR/tree-installer-system/update-sources.list/run.sh

bash $SCRIPT_DIR/tree-installer-system/network-manager/run.sh

bash $SCRIPT_DIR/tree-installer-system/clean-network-interfaces/run.sh

bash $SCRIPT_DIR/tree-installer-system/update-adduser/run.sh

bash $SCRIPT_DIR/tree-installer-system/hide-kernel-messages/run.sh

bash $SCRIPT_DIR/tree-installer-system/update-os-release/run.sh

bash $SCRIPT_DIR/tree-installer-system/flatpak-installer/run.sh

bash $SCRIPT_DIR/tree-installer-system/grub-settings/run.sh

# bash $SCRIPT_DIR/tree-installer-system/lightdm-settings/run.sh

bash $SCRIPT_DIR/tree-installer-system/core/run.sh

bash $SCRIPT_DIR/tree-installer-system/satellaos-plugins/run.sh

bash $SCRIPT_DIR/tree-installer-system/grub-theme/run.sh

bash $SCRIPT_DIR/tree-installer-system/themes/run.sh

bash $SCRIPT_DIR/tree-installer-system/pictures/run.sh

# bash $SCRIPT_DIR/tree-installer-system/xfce-interface/run.sh

bash $SCRIPT_DIR/tree-installer-system/font-installer/run.sh
