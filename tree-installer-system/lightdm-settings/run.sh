#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "Updating The LightDM Settings"

sudo cp $SCRIPT_DIR/lightdm/* /etc/lightdm/
