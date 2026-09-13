#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "Updating The os-release File"

sudo cp $SCRIPT_DIR/os-release /etc/os-release
