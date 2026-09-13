#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

while true; do
    read -p "Do you want to install fastfetch? (Y/N): " install_choice
    case "$install_choice" in
        [yY])
            sudo apt install --no-install-recommends -y fastfetch

            while true; do
                read -p "Do you want to apply SatellaOS's custom fastfetch configuration? (Y/N): " config_choice
                case "$config_choice" in
                    [yY])
                        mkdir -p "$HOME/.config/fastfetch"
                        cp "$SCRIPT_DIR/config.jsonc" "$HOME/.config/fastfetch/config.jsonc"
                        sudo mkdir -p /etc/skel/.config/fastfetch
                        sudo cp "$SCRIPT_DIR/config.jsonc" /etc/skel/.config/fastfetch/config.jsonc
                        break
                        ;;
                    [nN])
                        echo "Skipping custom configuration."
                        break
                        ;;
                    *)
                        echo "Invalid input! Please enter only 'Y' or 'N'."
                        ;;
                esac
            done
            break
            ;;
        [nN])
            echo "Skipping fastfetch installation."
            break
            ;;
        *)
            echo "Invalid input! Please enter only 'Y' or 'N'."
            ;;
    esac
done
