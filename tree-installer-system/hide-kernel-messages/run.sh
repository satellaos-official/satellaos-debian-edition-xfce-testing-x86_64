#!/usr/bin/env bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "Kernel messages are being silent."

set -euo pipefail

sudo cp $SCRIPT_DIR/99-silent-kernel.conf /etc/sysctl.d/99-silent-kernel.conf

sudo sysctl --system
