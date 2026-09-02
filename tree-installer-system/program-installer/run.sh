#!/bin/bash
# ==============================================================================
# SatellaOS Program Installer (Debian Edition)
# ==============================================================================

source "$HOME/.satellaos-source/installer"

mkdir -p /tmp/$project_name/temporary-files/

sudo apt install --install-recommends -y jq gpg whiptail

# ------------------------------------------------------------------------------
# Program List (tag / description / default state)
# ------------------------------------------------------------------------------

PROGRAM_OPTIONS=(
    "01" "Brave Browser (Deb)"                OFF
    "02" "Chromium Browser (Deb)"             OFF
    "03" "Firefox ESR (Deb)"                  OFF
    "04" "Firefox Stable (Portable)"          OFF
    "05" "Floorp Browser (Portable)"          OFF
    "06" "Floorp Browser (Deb)"               OFF
    "07" "Google Chrome Stable (Deb)"         OFF
    "08" "Opera Browser Stable (Deb)"         OFF
    "09" "Tor Browser (Deb)"                  OFF
    "10" "Vivaldi Stable (Deb)"               OFF
    "11" "Zen Browser (Portable)"             OFF
    "12" "Baobab Disk Usage Analyzer (Deb)"   OFF
    "13" "Bitwarden (Flatpak)"                OFF
    "14" "Bleachbit (Deb)"                    OFF
    "15" "Discord (Flatpak)"                  OFF
    "16" "Engrampa File Manager (Deb)"        OFF
    "17" "Flatseal (Flatpak)"                 OFF
    "18" "Free Download Manager (Deb)"        OFF
    "19" "Galculator (Deb)"                   OFF
    "20" "Ghostwritter (Deb)"                 OFF
    "21" "GIMP (Deb)"                         OFF
    "22" "GIMP (Flatpak)"                     OFF
    "23" "Gnome Characters (Deb)"             OFF
    "24" "Gnome Disk Utility (Deb)"           OFF
    "25" "Gnome Software (Deb)"               OFF
    "26" "GParted (Deb)"                      OFF
    "27" "GRUB Customizer (Deb)"              OFF
    "28" "Gucharmap (Deb)"                    OFF
    "29" "Heroic Games Launcher (Deb)"        OFF
    "30" "Heroic Games Launcher (Flatpak)"    OFF
    "31" "Inkscape (Deb)"                     OFF
    "32" "KDE Connect (Deb)"                  OFF
    "33" "KDE Discover (Deb)"                 OFF
    "34" "KeePassXC (Deb)"                    OFF
    "35" "Krita (Flatpak)"                    OFF
    "36" "LibreOffice All (Deb)"              OFF
    "37" "LightDM GTK Greeter Settings (Deb)" OFF
    "38" "LocalSend (Deb)"                    OFF
    "39" "Lutris (Deb)"                       OFF
    "40" "Lutris (Flatpak)"                   OFF
    "41" "MenuLibre (Deb)"                    OFF
    "42" "MintStick (Deb)"                    OFF
    "43" "Mission Center (Flatpak)"           OFF
    "44" "Mousepad Text Editor (Deb)"         OFF
    "45" "OBS Studio (Flatpak)"               OFF
    "46" "Onboard Screen Keyboard (Deb)"      OFF
    "47" "Pinta (Flatpak)"                    OFF
    "48" "PowerISO (Flatpak)"                 OFF
    "49" "Proton VPN (Unofficial - Flatpak)"  OFF
    "50" "qBittorrent (Deb)"                  OFF
    "51" "QEMU - CLI (Deb)"                   OFF
    "52" "QEMU - GUI (Deb)"                   OFF
    "53" "Ristretto (Deb)"                    OFF
    "54" "Signal (Deb)"                       OFF
    "55" "Steam (Deb)"                        OFF
    "56" "Sublime Text (Deb)"                 OFF
    "57" "Telegram (Flatpak)"                 OFF
    "58" "Thunderbird (Flatpak)"              OFF
    "59" "Timeshift (Deb)"                    OFF
    "60" "Unrar Free (Deb)"                   OFF
    "61" "Unrar Non-Free (Deb)"               OFF
    "62" "VirtualBox (Deb)"                   OFF
    "63" "VLC Media Player (Deb)"             OFF
    "64" "VS Code (Deb)"                      OFF
    "65" "WineHQ Stable (Deb)"                OFF
    "66" "Wireshark (Deb)"                    OFF
    "67" "XFCE4 Screenshotter (Deb)"          OFF
    "68" "XFCE4 Task Manager (Deb)"           OFF
)

declare -A PROGRAM_NAMES
for ((i = 0; i < ${#PROGRAM_OPTIONS[@]}; i += 3)); do
    PROGRAM_NAMES["${PROGRAM_OPTIONS[i]}"]="${PROGRAM_OPTIONS[i+1]}"
done

# ------------------------------------------------------------------------------
# Selection Screen
# ------------------------------------------------------------------------------

SELECTED_TAGS=()

while true; do
    # Rebuild the checklist options, marking previously selected tags as ON
    # so choices are preserved when returning from the confirmation screen.
    CHECKLIST_OPTIONS=()
    for ((i = 0; i < ${#PROGRAM_OPTIONS[@]}; i += 3)); do
        tag="${PROGRAM_OPTIONS[i]}"
        desc="${PROGRAM_OPTIONS[i+1]}"
        state="OFF"
        for sel in "${SELECTED_TAGS[@]}"; do
            if [ "$sel" == "$tag" ]; then
                state="ON"
                break
            fi
        done
        CHECKLIST_OPTIONS+=("$tag" "$desc" "$state")
    done

    CHOICES=$(whiptail --title "SatellaOS Program Installer" \
        --checklist "Select the programs you want to install:\n(SPACE: Select | ENTER: Confirm | TAB: Switch)" \
        26 78 16 \
        "${CHECKLIST_OPTIONS[@]}" \
        3>&1 1>&2 2>&3)

    EXIT_STATUS=$?

    if [ $EXIT_STATUS -ne 0 ] || [ -z "$CHOICES" ]; then
        echo "No programs selected. Exiting."
        exit 0
    fi

    # Convert whiptail's quoted, space-separated output into an array of tags
    eval "SELECTED_TAGS=($CHOICES)"

    # --------------------------------------------------------------------------
    # Confirmation Screen
    # --------------------------------------------------------------------------

    CONFIRM_TEXT=""
    for tag in "${SELECTED_TAGS[@]}"; do
        CONFIRM_TEXT+="${PROGRAM_NAMES[$tag]}\n"
    done

    whiptail --title "Confirm Installation" \
        --yes-button "Yes" --no-button "Back" \
        --yesno "The following programs will be installed:\n\n${CONFIRM_TEXT}" \
        26 78

    if [ $? -eq 0 ]; then
        break
    fi
    # "Back" selected: loop back to the checklist screen
done

# ------------------------------------------------------------------------------
# Install Functions
# ------------------------------------------------------------------------------

install_01() { # Brave Browser (Deb)
    sudo curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg
    sudo curl -fsSLo /etc/apt/sources.list.d/brave-browser-release.sources https://brave-browser-apt-release.s3.brave.com/brave-browser.sources
    sudo apt update
    sudo apt install --install-recommends -y brave-browser
}

install_02() { # Chromium Browser (Deb)
    sudo apt install --install-recommends -y chromium
}

install_03() { # Firefox ESR (Deb)
    sudo apt install --install-recommends -y firefox-esr
}

install_04() { # Firefox Stable (Portable)
    wget -O /tmp/$project_name/temporary-files/firefox-latest.tar.xz "https://download.mozilla.org/?product=firefox-latest-ssl&os=linux64&lang=en-US"

    sudo tar -xJf /tmp/$project_name/temporary-files/firefox-latest.tar.xz -C /opt/

    sudo tee /usr/share/applications/firefox.desktop > /dev/null <<'EOF'
[Desktop Entry]
Name=Firefox
Comment=Web Browser
Exec=/opt/firefox/firefox %u
Icon=/opt/firefox/browser/chrome/icons/default/default128.png
Terminal=false
Type=Application
Categories=Network;WebBrowser;
MimeType=text/html;text/xml;application/xhtml+xml;x-scheme-handler/http;x-scheme-handler/https;
StartupNotify=true
EOF

    sudo update-desktop-database /usr/share/applications 2>/dev/null || true
}

install_05() { # Floorp Browser (Portable)
    local github_owner="Floorp-Projects"
    local github_repo="Floorp"

    local DEST_DIR="/tmp/${project_name}/temporary-files"
    mkdir -p "$DEST_DIR"

    local API_URL="https://api.github.com/repos/${github_owner}/${github_repo}/releases/latest"
    local RELEASE_JSON=$(curl -s "${AUTH_HEADER[@]}" "$API_URL")

    local DOWNLOAD_URL=$(echo "$RELEASE_JSON" | jq -r '.assets[] | select(.name | test("x86_64\\.tar\\.xz$")) | .browser_download_url' | head -n1)

    local FILE_NAME=$(basename "$DOWNLOAD_URL")

    wget -O "${DEST_DIR}/${FILE_NAME}" "$DOWNLOAD_URL"

    sudo tar -xJf "${DEST_DIR}/${FILE_NAME}" -C /opt

    sudo tee /usr/share/applications/floorp.desktop > /dev/null <<'EOF'
[Desktop Entry]
Name=Floorp Browser
Comment=Web Browser
Exec=/opt/floorp/floorp %u
Icon=/opt/floorp/browser/chrome/icons/default/default128.png
Terminal=false
Type=Application
Categories=Network;WebBrowser;
MimeType=text/html;text/xml;application/xhtml+xml;x-scheme-handler/http;x-scheme-handler/https;
StartupNotify=true
EOF
    sudo update-desktop-database /usr/share/applications 2>/dev/null || true
}

install_06() { # Floorp Browser (Deb)
    curl -fsSL https://ppa.floorp.app/KEY.gpg | sudo gpg --dearmor -o /usr/share/keyrings/Floorp.gpg
    sudo curl -sS --compressed -o /etc/apt/sources.list.d/Floorp.list 'https://ppa.floorp.app/Floorp.list'
    sudo apt update
    sudo apt install --install-recommends -y floorp
}

install_07() { # Google Chrome Stable (Deb)
    wget -O "/tmp/$project_name/temporary-files/google-chrome-stable.deb" "https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb"
    sudo apt install --install-recommends -y "/tmp/$project_name/temporary-files/google-chrome-stable.deb"
}

install_08() { # Opera Browser Stable (Deb)
    wget -O- https://deb.opera.com/archive.key | gpg --dearmor | sudo dd of=/usr/share/keyrings/opera-browser.gpg
    echo "deb [signed-by=/usr/share/keyrings/opera-browser.gpg] https://deb.opera.com/opera-stable/ stable non-free" | sudo dd of=/etc/apt/sources.list.d/opera-archive.list
    sudo apt update
    sudo apt install --install-recommends -y opera-stable
}

install_09() { # Tor Browser (Deb)
    sudo apt install --install-recommends -y torbrowser-launcher
}

install_10() { # Vivaldi Stable (Deb)
    sudo install -d -m 0755 /usr/share/keyrings

    wget -O- https://repo.vivaldi.com/archive/linux_signing_key.pub | \
        sudo gpg --dearmor -o /usr/share/keyrings/vivaldi-browser.gpg

    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/vivaldi-browser.gpg] https://repo.vivaldi.com/archive/deb/ stable main" \
        | sudo tee /etc/apt/sources.list.d/vivaldi.list

    sudo apt update
    sudo apt install --install-recommends -y vivaldi-stable
}

install_11() { # Zen Browser (Portable)
    local github_owner="zen-browser"
    local github_repo="desktop"

    local DEST_DIR="/tmp/${project_name}/temporary-files"
    mkdir -p "$DEST_DIR"

    local API_URL="https://api.github.com/repos/${github_owner}/${github_repo}/releases/latest"
    local RELEASE_JSON=$(curl -s "${AUTH_HEADER[@]}" "$API_URL")

    local DOWNLOAD_URL=$(echo "$RELEASE_JSON" | jq -r '.assets[] | select(.name | test("x86_64\\.tar\\.xz$")) | .browser_download_url' | head -n1)

    local FILE_NAME=$(basename "$DOWNLOAD_URL")

    wget -O "${DEST_DIR}/${FILE_NAME}" "$DOWNLOAD_URL"

    sudo tar -xJf "${DEST_DIR}/${FILE_NAME}" -C /opt

    sudo tee /usr/share/applications/zen.desktop > /dev/null <<'EOF'
[Desktop Entry]
Name=Zen Browser
Comment=Web Browser
Exec=/opt/zen/zen %u
Icon=/opt/zen/browser/chrome/icons/default/default128.png
Terminal=false
Type=Application
Categories=Network;WebBrowser;
MimeType=text/html;text/xml;application/xhtml+xml;x-scheme-handler/http;x-scheme-handler/https;
StartupNotify=true
EOF
    sudo update-desktop-database /usr/share/applications 2>/dev/null || true
}

install_12() { # Baobab Disk Usage Analyzer (Deb)
    sudo apt install --install-recommends -y baobab
}

install_13() { # Bitwarden (Flatpak)
    flatpak install -y --noninteractive --system flathub com.bitwarden.desktop
}

install_14() { # Bleachbit (Deb)
    sudo apt install --install-recommends -y bleachbit
}

install_15() { # Discord (Flatpak)
    flatpak install -y --noninteractive --system flathub com.discordapp.Discord
}

install_16() { # Engrampa File Manager (Deb)
    sudo apt install --no-install-recommends -y engrampa
}

install_17() { # Flatseal (Flatpak)
    flatpak install -y --noninteractive --system flathub com.github.tchx84.Flatseal
}

install_18() { # Free Download Manager (Deb)
    wget -O "/tmp/$project_name/temporary-files/free-download-manager.deb" "https://files2.freedownloadmanager.org/6/latest/freedownloadmanager.deb"
    sudo apt install --install-recommends -y "/tmp/$project_name/temporary-files/free-download-manager.deb"
}

install_19() { # Galculator (Deb)
    sudo apt install --no-install-recommends -y galculator
}

install_20() { # Ghostwritter (Deb)
    sudo apt install --install-recommends -y ghostwritter
}

install_21() { # GIMP (Deb)
    sudo apt install --install-recommends -y gimp
}

install_22() { # GIMP (Flatpak)
    flatpak install -y --noninteractive --system flathub org.gimp.GIMP
}

install_23() { # Gnome Characters (Deb)
    sudo apt install --no-install-recommends -y gnome-characters
}

install_24() { # Gnome Disk Utility (Deb)
    sudo apt install --no-install-recommends -y gnome-disk-utility
}

install_25() { # Gnome Software (Deb)
    sudo apt install --no-install-recommends -y gnome-software \
        gnome-software-common \
        gnome-software-plugin-deb \
        gnome-software-plugin-flatpak
}

install_26() { # GParted (Deb)
    sudo apt install --install-recommends -y gparted
}

install_27() { # GRUB Customizer (Deb)
    sudo apt install --install-recommends -y grub-customizer
}

install_28() { # Gucharmap (Deb)
    sudo apt install --install-recommends -y gucharmap
}

install_29() { # Heroic Games Launcher (Deb)
    local github_owner="Heroic-Games-Launcher"
    local github_repo="HeroicGamesLauncher"

    local DEST_DIR="/tmp/${project_name}/temporary-files"
    mkdir -p "$DEST_DIR"

    local API_URL="https://api.github.com/repos/${github_owner}/${github_repo}/releases/latest"
    local RELEASE_JSON=$(curl -s "${AUTH_HEADER[@]}" "$API_URL")
    local DOWNLOAD_URL=$(echo "$RELEASE_JSON" | jq -r '.assets[] | select(.name | test("linux-amd64\\.deb$")) | .browser_download_url' | head -n1)

    local FILE_NAME=$(basename "$DOWNLOAD_URL")

    wget -O "${DEST_DIR}/${FILE_NAME}" "$DOWNLOAD_URL"

    sudo apt install --install-recommends -y "${DEST_DIR}/${FILE_NAME}"
}

install_30() { # Heroic Games Launcher (Flatpak)
    flatpak install -y --noninteractive --system com.heroicgameslauncher.hgl
}

install_31() { # Inkscape (Deb)
    sudo apt install --install-recommends -y inkscape
}

install_32() { # KDE Connect (Deb)
    sudo apt install --no-install-recommends -y kdeconnect qrencode
}

install_33() { # KDE Discover (Deb)
    sudo apt install --no-install-recommends -y plasma-discover plasma-discover-backend-flatpak
}

install_34() { # KeePassXC (Deb)
    sudo apt install --install-recommends -y keepassxc
}

install_35() { # Krita (Flatpak)
    flatpak install -y --noninteractive --system flathub org.kde.krita
}

install_36() { # LibreOffice All (Deb)
    sudo apt install --install-recommends -y libreoffice
}

install_37() { # LightDM GTK Greeter Settings (Deb)
    sudo apt install --no-install-recommends -y lightdm-gtk-greeter-settings
}

install_38() { # LocalSend (Deb)
    local github_owner="localsend"
    local github_repo="localsend"

    local DEST_DIR="/tmp/${project_name}/temporary-files"
    mkdir -p "$DEST_DIR"

    local API_URL="https://api.github.com/repos/${github_owner}/${github_repo}/releases/latest"
    local RELEASE_JSON=$(curl -s "${AUTH_HEADER[@]}" "$API_URL")
    local DOWNLOAD_URL=$(echo "$RELEASE_JSON" | jq -r '.assets[] | select(.name | test("linux-x86-64\\.deb$")) | .browser_download_url' | head -n1)

    local FILE_NAME=$(basename "$DOWNLOAD_URL")

    wget -O "${DEST_DIR}/${FILE_NAME}" "$DOWNLOAD_URL"

    sudo apt install --install-recommends -y "${DEST_DIR}/${FILE_NAME}"
}

install_39() { # Lutris (Deb)
    local github_owner="lutris"
    local github_repo="lutris"

    local DEST_DIR="/tmp/${project_name}/temporary-files"
    mkdir -p "$DEST_DIR"

    local API_URL="https://api.github.com/repos/${github_owner}/${github_repo}/releases/latest"
    local RELEASE_JSON=$(curl -s "${AUTH_HEADER[@]}" "$API_URL")
    local DOWNLOAD_URL=$(echo "$RELEASE_JSON" | jq -r '.assets[] | select(.name | test("all\\.deb$")) | .browser_download_url' | head -n1)

    local FILE_NAME=$(basename "$DOWNLOAD_URL")

    wget -O "${DEST_DIR}/${FILE_NAME}" "$DOWNLOAD_URL"

    sudo apt install --install-recommends -y "${DEST_DIR}/${FILE_NAME}"
}

install_40() { # Lutris (Flatpak)
    flatpak install -y --noninteractive --system flathub net.lutris.Lutris
}

install_41() { # MenuLibre (Deb)
    sudo apt install --install-recommends -y menulibre
}

install_42() { # MintStick (Deb)
    sudo apt install --install-recommends -y mintstick
}

install_43() { # Mission Center (Flatpak)
    flatpak install -y --noninteractive --system flathub io.missioncenter.MissionCenter
}

install_44() { # Mousepad Text Editor (Deb)
    sudo apt install --no-install-recommends -y mousepad
}

install_45() { # OBS Studio (Flatpak)
    flatpak install -y --noninteractive --system flathub com.obsproject.Studio
}

install_46() { # Onboard (Deb)
    sudo apt install --no-install-recommends -y onboard
}

install_47() { # Pinta (Flatpak)
    flatpak install -y --noninteractive --system flathub com.github.PintaProject.Pinta
}

install_48() { # PowerISO (Flatpak)
    flatpak install -y --noninteractive --system flathub com.poweriso.PowerISO
}

install_49() { # Proton VPN (Unofficial - Flatpak)
    flatpak install -y --noninteractive --system flathub com.protonvpn.www
}

install_50() { # qBittorrent (Deb)
    sudo apt install --install-recommends -y qbittorrent
}

install_51() { # QEMU - CLI (Deb)
    sudo apt install --install-recommends -y qemu-system-x86 qemu-utils qemu-kvm
    sudo virsh net-autostart default
}

install_52() { # QEMU - GUI (Deb) — installed with virt-manager as the standard front end
    sudo apt install --install-recommends -y qemu-system-x86 qemu-utils qemu-kvm libvirt-daemon-system \
        libvirt-clients bridge-utils virt-manager

    sudo systemctl enable libvirtd
    sudo systemctl enable virtlogd

    sudo usermod -aG libvirt,kvm $USER

    sudo virsh net-autostart default
}

install_53() { # Ristretto (Deb)
    sudo apt install --no-install-recommends -y ristretto libwebp7 tumbler tumbler-plugins-extra webp-pixbuf-loader
}

install_54() { # Signal (Deb)
    curl https://updates.signal.org/desktop/apt/keys.asc | gpg --dearmor > signal-desktop-keyring.gpg
    cat signal-desktop-keyring.gpg | sudo tee /usr/share/keyrings/signal-desktop-keyring.gpg > /dev/null

    curl -o signal-desktop.sources https://updates.signal.org/static/desktop/apt/signal-desktop.sources
    cat signal-desktop.sources | sudo tee /etc/apt/sources.list.d/signal-desktop.sources > /dev/null

    sudo apt update
    sudo apt install --install-recommends -y signal-desktop
}

install_55() { # Steam (Deb)
    wget -O "/tmp/$project_name/temporary-files/steam.deb" "https://cdn.fastly.steamstatic.com/client/installer/steam.deb"
    sudo apt install --install-recommends -y "/tmp/$project_name/temporary-files/steam.deb"
}

install_56() { # Sublime Text (Deb)
    wget -O - https://download.sublimetext.com/sublimehq-pub.gpg | sudo tee /etc/apt/keyrings/sublimehq-pub.asc > /dev/null
    echo -e 'Types: deb\nURIs: https://download.sublimetext.com/\nSuites: apt/stable/\nSigned-By: /etc/apt/keyrings/sublimehq-pub.asc' | sudo tee /etc/apt/sources.list.d/sublime-text.sources
    sudo apt update
    sudo apt install --install-recommends -y sublime-text
}

install_57() { # Telegram (Flatpak)
    flatpak install -y --noninteractive --system flathub org.telegram.desktop
}

install_58() { # Thunderbird (Flatpak)
    flatpak install -y --noninteractive --system flathub org.mozilla.thunderbird
}

install_59() { # Timeshift (Deb)
    sudo apt install --install-recommends -y timeshift
}

install_60() { # Unrar Free (Deb)
    sudo apt install --install-recommends -y unrar-free
}

install_61() { # Unrar Non-Free (Deb)
    sudo apt install --install-recommends -y unrar
}

install_62() { # VirtualBox (Deb)
    wget -qO- https://www.virtualbox.org/download/oracle_vbox_2016.asc | sudo gpg --dearmor -o /usr/share/keyrings/oracle_vbox_2016.gpg
    echo "deb [arch=amd64 signed-by=/usr/share/keyrings/oracle_vbox_2016.gpg] http://download.virtualbox.org/virtualbox/debian trixie contrib" | sudo tee /etc/apt/sources.list.d/virtualbox.list
    sudo apt update
    sudo apt install --install-recommends -y virtualbox-7.2
}

install_63() { # VLC Media Player (Deb)
    sudo apt install --install-recommends -y vlc
}

install_64() { # VS Code (Deb)
    sudo apt install wget gpg
    wget -O- https://packages.microsoft.com/keys/microsoft.asc | sudo gpg --dearmor -o /usr/share/keyrings/microsoft.gpg

    sudo tee /etc/apt/sources.list.d/vscode.sources > /dev/null << 'EOF'
Types: deb
URIs: https://packages.microsoft.com/repos/code
Suites: stable
Components: main
Architectures: amd64,arm64,armhf
Signed-By: /usr/share/keyrings/microsoft.gpg
EOF

    sudo apt update
    sudo apt install --install-recommends -y code
}

install_65() { # WineHQ Stable (Deb)
    sudo mkdir -pm755 /etc/apt/keyrings
    wget -O - https://dl.winehq.org/wine-builds/winehq.key | sudo gpg --dearmor -o /etc/apt/keyrings/winehq-archive.key -

    sudo dpkg --add-architecture i386

    sudo wget -NP /etc/apt/sources.list.d/ https://dl.winehq.org/wine-builds/debian/dists/trixie/winehq-trixie.sources

    sudo apt update
    sudo apt install --install-recommends -y winehq-stable
}

install_66() { # Wireshark (Deb)
    sudo apt install --install-recommends -y wireshark
}

install_67() { # XFCE4 Screenshotter (Deb)
    sudo apt install --no-install-recommends -y xfce4-screenshooter
}

install_68() { # XFCE4 Task Manager (Deb)
    sudo apt install --no-install-recommends -y xfce4-taskmanager
}

# ------------------------------------------------------------------------------
# Run Installations
# ------------------------------------------------------------------------------

for tag in "${SELECTED_TAGS[@]}"; do
    echo "==> Installing: ${PROGRAM_NAMES[$tag]}"
    "install_${tag}"
done

echo "All selected programs have been installed."

# ------------------------------------------------------------------------------
# Cleanup
# ------------------------------------------------------------------------------

rm -rf /tmp/$project_name/temporary-files/
