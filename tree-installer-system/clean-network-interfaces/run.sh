#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

sudo cp $SCRIPT_DIR/interfaces /etc/network/interfaces
