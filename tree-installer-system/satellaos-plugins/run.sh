#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

sudo apt install --install-recommends -y "$SCRIPT_DIR/dist"/satella-appmenu-plugin*.deb
