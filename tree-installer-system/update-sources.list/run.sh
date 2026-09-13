#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "Enabling The Non-Free Repos"

sudo cp $SCRIPT_DIR/sources.list /etc/apt/sources.list

sudo apt update
