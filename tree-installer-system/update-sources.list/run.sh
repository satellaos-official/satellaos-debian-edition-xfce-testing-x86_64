#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

sudo cp $SCRIPT_DIR/sources.list /etc/apt/sources.list
sudo apt update
sudo apt upgrade -y
