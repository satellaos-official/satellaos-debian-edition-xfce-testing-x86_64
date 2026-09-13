#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "Installing The SatellaOS Pictures"

sudo mkdir -p /usr/share/satellaos-core/pictures/

sudo cp -r $SCRIPT_DIR/satellaos-sirius/* /usr/share/satellaos-core/pictures/
