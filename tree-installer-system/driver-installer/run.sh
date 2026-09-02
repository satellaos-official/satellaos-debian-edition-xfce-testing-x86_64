#!/bin/bash
# ---------------------------------------------------------------------------
# Driver Installer - Whiptail Interactive Script
# ---------------------------------------------------------------------------
# Lets the user pick which drivers/tools to install via a checklist, shows
# a confirmation screen listing the selected item names, then installs them.
# ---------------------------------------------------------------------------

set -uo pipefail

# Make sure whiptail is available
if ! command -v whiptail >/dev/null 2>&1; then
    echo "whiptail is not installed. Install it with: sudo apt install whiptail" >&2
    exit 1
fi

# ---------------------------------------------------------------------------
# Checklist definition
# Each entry: "TAG" "Display Name" "OFF"
# ---------------------------------------------------------------------------
CHOICES=$(whiptail \
    --title "SatellaOS Driver Installer" \
    --checklist "Select the drivers you want to install:\n(SPACE: Select | ENTER: Confirm | TAB: Switch)" \
    30 72 17 \
    "01" "AMD Graphics Driver"              OFF \
    "02" "Intel Graphics Driver"            OFF \
    "03" "NVIDIA Nouveau Graphics Driver"   OFF \
    "04" "VMware Guest Tools"               OFF \
    "05" "VirtualBox Guest Additions"       OFF \
    "06" "QEMU Guest Agent"                 OFF \
    "07" "QEMU QXL Driver"                  OFF \
    "08" "QEMU Spice"                       OFF \
    "09" "Broadcom Driver"                  OFF \
    "10" "Realtek Driver"                   OFF \
    "11" "Atheros / Qualcomm Driver"        OFF \
    "12" "MediaTek Driver"                  OFF \
    "13" "Intel Wifi Driver"                OFF \
    "15" "ADB Driver (Android)"             OFF \
    "16" "General Bluetooth Driver"         OFF \
    "17" "General WiFi Driver"              OFF \
    "18" "General Audio Driver"             OFF \
    3>&1 1>&2 2>&3)

EXIT_STATUS=$?

if [ $EXIT_STATUS -ne 0 ]; then
    echo "Cancelled by user."
    exit 1
fi

if [ -z "$CHOICES" ]; then
    whiptail --title "Nothing Selected" \
        --msgbox "No items were selected. Exiting." 8 50
    exit 0
fi

# CHOICES comes back as a space-separated, quoted list like: "01" "06" "08"
CHOICES=$(echo "$CHOICES" | tr -d '"')

# ---------------------------------------------------------------------------
# Map tags -> display name
# ---------------------------------------------------------------------------
declare -A NAME_MAP=(
    ["01"]="AMD Graphics Driver"
    ["02"]="Intel Graphics Driver"
    ["03"]="NVIDIA Nouveau Graphics Driver"
    ["04"]="VMware Guest Tools"
    ["05"]="VirtualBox Guest Additions"
    ["06"]="QEMU Guest Agent"
    ["07"]="QEMU QXL Driver"
    ["08"]="QEMU Spice"
    ["09"]="Broadcom Driver"
    ["10"]="Realtek Driver"
    ["11"]="Atheros / Qualcomm Driver"
    ["12"]="MediaTek Driver"
    ["13"]="Intel Wifi Driver"
    ["15"]="ADB Driver (Android)"
    ["16"]="General Bluetooth Driver"
    ["17"]="General WiFi Driver"
    ["18"]="General Audio Driver"
)

# ---------------------------------------------------------------------------
# Build the confirmation message: one selected name per line
# ---------------------------------------------------------------------------
SUMMARY=""
for TAG in $CHOICES; do
    SUMMARY+="${NAME_MAP[$TAG]}"$'\n'
done

whiptail --title "Confirm Selection" \
    --yesno "The following will be installed:

${SUMMARY}
Proceed with installation?" 24 70

if [ $? -ne 0 ]; then
    echo "Installation cancelled by user."
    exit 1
fi

# ---------------------------------------------------------------------------
# Install functions per tag
# ---------------------------------------------------------------------------
install_item() {
    local tag="$1"
    case "$tag" in
        01)
            sudo apt install --install-recommends -y firmware-amd-graphics mesa-vulkan-drivers libgl1-mesa-dri
            ;;
        02)
            sudo apt install --install-recommends -y intel-media-va-driver mesa-vulkan-drivers libgl1-mesa-dri
            ;;
        03)
            sudo apt install --install-recommends -y xserver-xorg-video-nouveau mesa-vulkan-drivers libgl1-mesa-dri
            ;;
        04)
            sudo apt install --install-recommends -y open-vm-tools open-vm-tools-desktop
            ;;
        05)
            WORKDIR="/tmp/vbox-guest-tool-install"
            EXTRACT_DIR="$WORKDIR/vbox-guest-tool"
            mkdir -p "$WORKDIR"

            VERSION=$(wget -qO- "https://download.virtualbox.org/virtualbox/LATEST-STABLE.TXT")
            ISO_PATH="$WORKDIR/VBoxGuestAdditions_${VERSION}.iso"

            wget -O "$ISO_PATH" "https://download.virtualbox.org/virtualbox/${VERSION}/VBoxGuestAdditions_${VERSION}.iso"
            mkdir -p "$EXTRACT_DIR"

            if command -v 7z >/dev/null 2>&1; then
                7z x "$ISO_PATH" -o"$EXTRACT_DIR" -y
            elif command -v bsdtar >/dev/null 2>&1; then
                bsdtar -xf "$ISO_PATH" -C "$EXTRACT_DIR"
            else
                echo "Neither 7z nor bsdtar found; cannot extract VBox Guest Additions ISO." >&2
                return 1
            fi

            sudo sh "$EXTRACT_DIR/VBoxLinuxAdditions.run"
            ;;
        06)
            sudo apt install --install-recommends -y qemu-guest-agent
            ;;
        07)
            sudo apt install --install-recommends -y xserver-xorg-video-qxl
            ;;
        08)
            sudo apt install --install-recommends -y spice-vdagent spice-webdavd
            ;;
        09)
            sudo apt install --install-recommends -y firmware-brcm80211
            ;;
        10)
            sudo apt install --install-recommends -y firmware-realtek
            ;;
        11)
            sudo apt install --install-recommends -y firmware-atheros
            ;;
        12)
            sudo apt install --install-recommends -y firmware-mediatek
            ;;
        13)
            sudo apt install --install-recommends -y firmware-iwlwifi
            ;;
        15)
            sudo apt install --install-recommends -y android-sdk-platform-tools-common adb fastboot
            ;;
        16)
            sudo apt install --install-recommends -y bluez bluez-firmware blueman bluetooth
            ;;
        17)
            sudo apt install --install-recommends -y firmware-linux firmware-misc-nonfree wireless-tools wpasupplicant
            ;;
        18)
            sudo apt install --install-recommends -y firmware-sof-signed alsa-utils pulseaudio xfce4-pulseaudio-plugin
            ;;
        *)
            echo "Unknown tag: $tag" >&2
            return 1
            ;;
    esac
}

# ---------------------------------------------------------------------------
# Run the installation
# ---------------------------------------------------------------------------
sudo apt update

for TAG in $CHOICES; do
    echo "Installing: ${NAME_MAP[$TAG]}"
    install_item "$TAG"
done

echo "Installation finished."

exit 0
