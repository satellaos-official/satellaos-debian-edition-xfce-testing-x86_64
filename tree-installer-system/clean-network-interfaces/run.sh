#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "Cleaning The /etc/network/interfaces File"

sudo cp $SCRIPT_DIR/interfaces /etc/network/interfaces
