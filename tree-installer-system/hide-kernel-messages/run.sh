#!/usr/bin/env bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

sudo cp $SCRIPT_DIR/99-silent-kernel.conf /etc/sysctl.d/99-silent-kernel.conf
