#!/usr/bin/env bash
#
# Program Installer for Debian 13 (Trixie) XFCE
# Shows a whiptail checklist of programs and installs the selected ones.
#
# Usage: ./program-installer.sh

set -u

INSTALL_DIR="/tmp/programs"
LOG_FILE="/tmp/program-installer.log"

# ---------------------------------------------------------------------------
# Program list: "Name|Method"  (index + 1 = item number)
# ---------------------------------------------------------------------------
PROGRAMS=(
    "Brave|Apt"
    "Chrome|Apt"
    "Chromium|Apt"
    "Firefox ESR|Apt"
    "Firefox Stable|Apt"
    "Floorp|Apt"
    "Opera|Apt"
    "Vivaldi|Apt"
    "Tor|Apt"
    "Zen Browser|Archive"
    "Waterfox|Apt"
    "Bitwarden|Flatpak"
    "Bleachbit|Apt"
    "Celluloid|Apt"
    "Discord|Flatpak"
    "Flatseal|Flatpak"
    "Free Download Manager|Apt"
    "Free Download Manager|Flatpak"
    "Galculator|Apt"
    "Ghostwriter|Apt"
    "GIMP|Apt"
    "GIMP|Flatpak"
    "Gnome Characters|Apt"
    "Gnome Disk Utility|Apt"
    "Gnome Software|Apt"
    "GParted|Apt"
    "GRUB Customizer|Apt"
    "Gucharmap|Apt"
    "Heroic Games Launcher|Apt"
    "Heroic Games Launcher|Flatpak"
    "Inkscape|Apt"
    "Inkscape|Flatpak"
    "KDE Connect|Apt"
    "KDE Discover|Apt"
    "KeePassXC|Apt"
    "Krita|Apt"
    "Krita|Flatpak"
    "Libreoffice Writer|Apt"
    "Libreoffice Calc|Apt"
    "Libreoffice Impress|Apt"
    "Libreoffice Draw|Apt"
    "Libreoffice Base|Apt"
    "Libreoffice Math|Apt"
    "Libreoffice All|Apt"
    "Localsend|Apt"
    "Localsend|Flatpak"
    "Lutris|Apt"
    "Lutris|Flatpak"
    "Menulibre|Apt"
    "Mint Stick|Apt"
    "Mission Center|Flatpak"
    "Mpv|Apt"
    "OBS Studio|Flatpak"
    "Pinta|Flatpak"
    "PowerISO Unofficial|Flatpak"
    "ProtonVPN Unofficial|Flatpak"
    "Qemu|Apt"
    "Virt Manager|Apt"
    "Signal|Apt"
    "Spotify Unofficial|Flatpak"
    "Steam|Apt"
    "Sublime Text|Apt"
    "Telegram|Flatpak"
    "Thunderbird|Apt"
    "Timeshift|Apt"
    "Unrar Free|Apt"
    "Unrar Non-Free|Apt"
    "Virtualbox|Apt"
    "VLC Media Player|Apt"
    "VS Code|Apt"
    "WineHQ Stable|Apt"
    "Wireshark|Apt"
    "XFCE4 Screen Saver|Apt"
    "XFCE4 Task Manager|Apt"
)

# ---------------------------------------------------------------------------
# Helpers
# ---------------------------------------------------------------------------
apt_install() {
    sudo apt install --install-recommends -y "$@"
}

apt_install_min() {
    sudo apt install --no-install-recommends -y "$@"
}

flatpak_install() {
    ensure_flatpak
    flatpak install -y flathub "$1"
}

ensure_flatpak() {
    if ! command -v flatpak >/dev/null 2>&1; then
        sudo apt update
        sudo apt install -y flatpak
    fi
    if ! flatpak remotes 2>/dev/null | grep -q '^flathub'; then
        sudo flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
    fi
}

check_requirements() {
    if ! command -v whiptail >/dev/null 2>&1; then
        echo "whiptail not found. Installing it..."
        sudo apt update && sudo apt install -y whiptail || exit 1
    fi
    if ! command -v sudo >/dev/null 2>&1; then
        echo "sudo is required but not installed." >&2
        exit 1
    fi
    for tool in curl wget gpg; do
        if ! command -v "$tool" >/dev/null 2>&1; then
            sudo apt update
            sudo apt install -y curl wget gpg ca-certificates
            break
        fi
    done
    mkdir -p "$INSTALL_DIR"
}

# ---------------------------------------------------------------------------
# Installation functions
# ---------------------------------------------------------------------------
install_01() { # Brave
    sudo curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg
    sudo curl -fsSLo /etc/apt/sources.list.d/brave-browser-release.sources https://brave-browser-apt-release.s3.brave.com/brave-browser.sources
    sudo apt update
    apt_install brave-browser
}

install_02() { # Chrome
    wget -O "$INSTALL_DIR/google-chrome-x86_64.deb" "https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb"
    apt_install "$INSTALL_DIR/google-chrome-x86_64.deb"
}

install_03() { # Chromium
    apt_install chromium
}

install_04() { # Firefox ESR
    apt_install firefox-esr
}

install_05() { # Firefox Stable
    sudo install -d -m 0755 /etc/apt/keyrings
    wget -q https://packages.mozilla.org/apt/repo-signing-key.gpg -O- | sudo tee /etc/apt/keyrings/packages.mozilla.org.asc > /dev/null
    echo "deb [signed-by=/etc/apt/keyrings/packages.mozilla.org.asc] https://packages.mozilla.org/apt mozilla main" | sudo tee /etc/apt/sources.list.d/mozilla.list > /dev/null
    echo '
Package: *
Pin: origin packages.mozilla.org
Pin-Priority: 1000
' | sudo tee /etc/apt/preferences.d/mozilla
    sudo apt update
    apt_install firefox
}

install_06() { # Floorp
    local deb_url
    deb_url=$(curl -s https://api.github.com/repos/Floorp-Projects/Floorp/releases/latest | grep "browser_download_url" | grep "\.deb" | cut -d '"' -f 4)
    wget -O "$INSTALL_DIR/floorp-latest.deb" "$deb_url"
    apt_install "$INSTALL_DIR/floorp-latest.deb"
}

install_07() { # Opera
    curl -fsSL https://deb.opera.com/archive.key | sudo gpg --dearmor --yes -o /usr/share/keyrings/opera-browser.gpg
    echo "deb [signed-by=/usr/share/keyrings/opera-browser.gpg] https://deb.opera.com/opera-stable/ stable non-free" | sudo tee /etc/apt/sources.list.d/opera-stable.list
    sudo apt update
    apt_install opera-stable
}

install_08() { # Vivaldi
    wget -qO- https://repo.vivaldi.com/archive/linux_signing_key.pub | sudo gpg --dearmor --yes -o /usr/share/keyrings/vivaldi-browser.gpg
    echo "deb [signed-by=/usr/share/keyrings/vivaldi-browser.gpg] http://repo.vivaldi.com/stable/deb/ stable main" | sudo tee /etc/apt/sources.list.d/vivaldi.list > /dev/null
    sudo apt update
    apt_install vivaldi-stable
}

install_09() { # Tor
    apt_install tor
}

install_10() { # Zen Browser
    local zen_api tar_url zen_version zen_pkg
    zen_api=$(curl -s https://api.github.com/repos/zen-browser/desktop/releases/latest)
    tar_url=$(echo "$zen_api" | grep "browser_download_url" | grep "zen\.linux-x86_64\.tar\.xz" | cut -d '"' -f 4)
    zen_version=$(echo "$zen_api" | grep '"tag_name"' | cut -d '"' -f 4 | sed 's/^v//; s/[^A-Za-z0-9.+~-]/~/g')
    case "$zen_version" in [0-9]*) ;; *) zen_version="0~$(date +%Y%m%d)" ;; esac

    zen_pkg="$INSTALL_DIR/zen-pkg"
    rm -rf "$zen_pkg"
    mkdir -p "$zen_pkg/DEBIAN" "$zen_pkg/opt/zen" "$zen_pkg/usr/bin" "$zen_pkg/usr/share/applications" "$zen_pkg/usr/share/xfce4/helpers"
    wget -O "$INSTALL_DIR/zen.linux-x86_64.tar.xz" "$tar_url"
    tar -xJf "$INSTALL_DIR/zen.linux-x86_64.tar.xz" -C "$zen_pkg/opt/zen" --strip-components=1

    # Updater policy
    mkdir -p "$zen_pkg/opt/zen/distribution"
    cat > "$zen_pkg/opt/zen/distribution/policies.json" <<'EOF'
{
  "policies": {
    "DisableAppUpdate": false
  }
}
EOF

    # Command-line launcher and icons
    ln -s /opt/zen/zen "$zen_pkg/usr/bin/zen"
    local size
    for size in 16 32 48 64 128; do
        mkdir -p "$zen_pkg/usr/share/icons/hicolor/${size}x${size}/apps"
        cp "$zen_pkg/opt/zen/browser/chrome/icons/default/default${size}.png" "$zen_pkg/usr/share/icons/hicolor/${size}x${size}/apps/zen-browser.png"
    done

    # Menu entry
    cat > "$zen_pkg/usr/share/applications/zen-browser.desktop" <<'EOF'
[Desktop Entry]
Version=1.0
Type=Application
Name=Zen Browser
GenericName=Web Browser
Comment=Browse the Web
Exec=/usr/bin/zen %u
Icon=zen-browser
Terminal=false
StartupNotify=true
StartupWMClass=zen
Categories=Network;WebBrowser;
MimeType=text/html;text/xml;application/xhtml+xml;application/xml;x-scheme-handler/http;x-scheme-handler/https;x-scheme-handler/about;x-scheme-handler/unknown;
Actions=new-window;new-private-window;

[Desktop Action new-window]
Name=New Window
Exec=/usr/bin/zen --new-window %u

[Desktop Action new-private-window]
Name=New Private Window
Exec=/usr/bin/zen --private-window %u
EOF

    # XFCE "Preferred Applications" entry
    cat > "$zen_pkg/usr/share/xfce4/helpers/zen-browser.desktop" <<'EOF'
[Desktop Entry]
NoDisplay=true
Version=1.0
Type=X-XFCE-Helper
X-XFCE-Category=WebBrowser
X-XFCE-CommandsWithParameter=zen "%s"
Icon=zen-browser
Name=Zen Browser
X-XFCE-Binaries=zen;
X-XFCE-Commands=zen
EOF

    # Package metadata and maintainer scripts
    cat > "$zen_pkg/DEBIAN/control" <<EOF
Package: zen-browser
Version: $zen_version
Architecture: amd64
Maintainer: Local Build <root@localhost>
Installed-Size: $(du -sk "$zen_pkg" | cut -f1)
Depends: libgtk-3-0t64 | libgtk-3-0, libasound2t64 | libasound2, libdbus-glib-1-2, libx11-xcb1, libxtst6, libxt6t64 | libxt6
Recommends: libpulse0, xdg-utils
Section: web
Priority: optional
Homepage: https://zen-browser.app
Description: Zen Browser - a privacy-focused, Firefox-based web browser
 Repackaged from the official upstream Linux release.
EOF

    cat > "$zen_pkg/DEBIAN/postinst" <<'EOF'
#!/bin/sh
set -e
if [ "$1" = "configure" ]; then
    update-alternatives --install /usr/bin/x-www-browser x-www-browser /usr/bin/zen 40 || true
    update-alternatives --install /usr/bin/gnome-www-browser gnome-www-browser /usr/bin/zen 40 || true
    if command -v update-desktop-database >/dev/null 2>&1; then
        update-desktop-database -q /usr/share/applications || true
    fi
    if command -v gtk-update-icon-cache >/dev/null 2>&1; then
        gtk-update-icon-cache -q -t -f /usr/share/icons/hicolor || true
    fi
fi
exit 0
EOF

    cat > "$zen_pkg/DEBIAN/prerm" <<'EOF'
#!/bin/sh
set -e
if [ "$1" = "remove" ] || [ "$1" = "deconfigure" ]; then
    update-alternatives --remove x-www-browser /usr/bin/zen || true
    update-alternatives --remove gnome-www-browser /usr/bin/zen || true
fi
exit 0
EOF

    cat > "$zen_pkg/DEBIAN/postrm" <<'EOF'
#!/bin/sh
set -e
if [ "$1" = "remove" ] || [ "$1" = "purge" ]; then
    if command -v update-desktop-database >/dev/null 2>&1; then
        update-desktop-database -q /usr/share/applications || true
    fi
    if command -v gtk-update-icon-cache >/dev/null 2>&1; then
        gtk-update-icon-cache -q -t -f /usr/share/icons/hicolor || true
    fi
fi
exit 0
EOF

    chmod 755 "$zen_pkg/DEBIAN/postinst" "$zen_pkg/DEBIAN/prerm" "$zen_pkg/DEBIAN/postrm"
    find "$zen_pkg" -type d -exec chmod 755 {} +

    # Build and install the package
    dpkg-deb --root-owner-group -Zxz --build "$zen_pkg" "$INSTALL_DIR/zen-browser.deb"
    apt_install "$INSTALL_DIR/zen-browser.deb"
    rm -rf "$zen_pkg" "$INSTALL_DIR/zen.linux-x86_64.tar.xz"
}

install_11() { # Waterfox
    curl -fsSL https://download.opensuse.org/repositories/isv:/BrowserWorks/Debian_13/Release.key \
        | gpg --dearmor | sudo tee /usr/share/keyrings/waterfox.gpg > /dev/null
    echo 'deb [signed-by=/usr/share/keyrings/waterfox.gpg] https://download.opensuse.org/repositories/isv:/BrowserWorks/Debian_13/ /' \
        | sudo tee /etc/apt/sources.list.d/waterfox.list
    sudo apt update
    apt_install waterfox
}

install_12() { flatpak_install com.bitwarden.desktop; }            # Bitwarden
install_13() { apt_install bleachbit; }                            # Bleachbit
install_14() { apt_install celluloid; }                            # Celluloid
install_15() { flatpak_install com.discordapp.Discord; }           # Discord
install_16() { flatpak_install com.github.tchx84.Flatseal; }       # Flatseal

install_17() { # Free Download Manager (Apt)
    wget -O "$INSTALL_DIR/FDM-x86_64.deb" "https://files2.freedownloadmanager.org/6/latest/freedownloadmanager.deb"
    apt_install "$INSTALL_DIR/FDM-x86_64.deb"
}

install_18() { flatpak_install org.freedownloadmanager.Manager; }  # Free Download Manager (Flatpak)
install_19() { apt_install galculator; }                           # Galculator
install_20() { apt_install ghostwriter; }                          # Ghostwriter
install_21() { apt_install gimp; }                                 # GIMP (Apt)
install_22() { flatpak_install org.gimp.GIMP; }                    # GIMP (Flatpak)
install_23() { apt_install gnome-characters; }                     # Gnome Characters
install_24() { apt_install gnome-disk-utility; }                   # Gnome Disk Utility
install_25() { apt_install gnome-software; }                       # Gnome Software
install_26() { apt_install gparted; }                              # GParted
install_27() { apt_install grub-customizer; }                      # GRUB Customizer
install_28() { apt_install gucharmap; }                            # Gucharmap
install_29() { apt_install heroic; }                               # Heroic (Apt)
install_30() { flatpak_install com.heroicgameslauncher.hgl; }      # Heroic (Flatpak)
install_31() { apt_install inkscape; }                             # Inkscape (Apt)
install_32() { flatpak_install org.inkscape.Inkscape; }            # Inkscape (Flatpak)
install_33() { apt_install_min kdeconnect; }                       # KDE Connect
install_34() { apt_install_min plasma-discover; }                  # KDE Discover
install_35() { apt_install keepassxc; }                            # KeePassXC
install_36() { apt_install krita; }                                # Krita (Apt)
install_37() { flatpak_install org.kde.krita; }                    # Krita (Flatpak)
install_38() { apt_install_min libreoffice-writer libreoffice-gtk3; }   # LibreOffice Writer
install_39() { apt_install_min libreoffice-calc libreoffice-gtk3; }     # LibreOffice Calc
install_40() { apt_install_min libreoffice-impress libreoffice-gtk3; }  # LibreOffice Impress
install_41() { apt_install_min libreoffice-draw libreoffice-gtk3; }     # LibreOffice Draw
install_42() { apt_install_min libreoffice-base libreoffice-gtk3; }     # LibreOffice Base
install_43() { apt_install_min libreoffice-math libreoffice-gtk3; }     # LibreOffice Math
install_44() { apt_install libreoffice libreoffice-gtk3; }              # LibreOffice All

install_45() { # Localsend (Apt)
    local deb_url
    deb_url=$(curl -s https://api.github.com/repos/localsend/localsend/releases/latest | grep -oE "https://[^\"]*linux-x86-64\.deb" | head -n1)
    wget -O "$INSTALL_DIR/localsend-x86_64.deb" "$deb_url"
    apt_install "$INSTALL_DIR/localsend-x86_64.deb"
}

install_46() { flatpak_install org.localsend.localsend_app; }      # Localsend (Flatpak)
install_47() { apt_install lutris; }                               # Lutris (Apt)
install_48() { flatpak_install net.lutris.Lutris; }                # Lutris (Flatpak)
install_49() { apt_install menulibre; }                            # Menulibre
install_50() { apt_install mintstick; }                            # Mint Stick
install_51() { flatpak_install io.missioncenter.MissionCenter; }   # Mission Center
install_52() { apt_install mpv; }                                  # Mpv
install_53() { flatpak_install com.obsproject.Studio; }            # OBS Studio
install_54() { flatpak_install com.github.PintaProject.Pinta; }    # Pinta
install_55() { flatpak_install com.poweriso.PowerISO; }            # PowerISO Unofficial
install_56() { flatpak_install com.protonvpn.www; }                # ProtonVPN Unofficial
install_57() { apt_install_min qemu-system-x86 qemu-utils libvirt-daemon-system; }  # Qemu
install_58() { apt_install_min virt-manager qemu-system-x86 qemu-utils libvirt-daemon-system libvirt-clients virtinst; }  # Virt Manager

install_59() { # Signal
    curl -fsSL https://updates.signal.org/desktop/apt/keys.asc | gpg --dearmor > "$INSTALL_DIR/signal-desktop-keyring.gpg"
    sudo tee /usr/share/keyrings/signal-desktop-keyring.gpg < "$INSTALL_DIR/signal-desktop-keyring.gpg" > /dev/null
    curl -fsSLo "$INSTALL_DIR/signal-desktop.sources" https://updates.signal.org/static/desktop/apt/signal-desktop.sources
    sudo tee /etc/apt/sources.list.d/signal-desktop.sources < "$INSTALL_DIR/signal-desktop.sources" > /dev/null
    sudo apt update
    apt_install signal-desktop
}

install_60() { flatpak_install com.spotify.Client; }               # Spotify Unofficial

install_61() { # Steam
    sudo dpkg --add-architecture i386
    curl -fsSL https://repo.steampowered.com/steam/archive/stable/steam.gpg | sudo tee /usr/share/keyrings/steam.gpg > /dev/null
    echo "deb [arch=amd64,i386 signed-by=/usr/share/keyrings/steam.gpg] https://repo.steampowered.com/steam/ stable steam" | sudo tee /etc/apt/sources.list.d/steam.list
    sudo apt update
    apt_install steam-launcher
}

install_62() { # Sublime Text
    sudo install -d -m 0755 /etc/apt/keyrings
    wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | sudo tee /etc/apt/keyrings/sublimehq-pub.asc > /dev/null
    echo -e 'Types: deb\nURIs: https://download.sublimetext.com/\nSuites: apt/stable/\nSigned-By: /etc/apt/keyrings/sublimehq-pub.asc' | sudo tee /etc/apt/sources.list.d/sublime-text.sources
    sudo apt update
    apt_install sublime-text
}

install_63() { flatpak_install org.telegram.desktop; }             # Telegram
install_64() { apt_install thunderbird; }                          # Thunderbird
install_65() { apt_install timeshift; }                            # Timeshift
install_66() { apt_install unrar-free; }                           # Unrar Free
install_67() { apt_install unrar; }                                # Unrar Non-Free

install_68() { # Virtualbox
    sudo apt install -y wget gnupg ca-certificates
    wget -O- https://www.virtualbox.org/download/oracle_vbox_2016.asc | sudo gpg --dearmor --yes --output /usr/share/keyrings/oracle_vbox_2016.gpg
    echo "deb [arch=amd64 signed-by=/usr/share/keyrings/oracle_vbox_2016.gpg] https://download.virtualbox.org/virtualbox/debian trixie contrib" | sudo tee /etc/apt/sources.list.d/virtualbox.list
    sudo apt update
    apt_install virtualbox-7.1
}

install_69() { apt_install vlc; }                                  # VLC

install_70() { # VS Code
    sudo apt update
    sudo apt install -y wget gpg apt-transport-https
    wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > "$INSTALL_DIR/microsoft.gpg"
    sudo install -D -o root -g root -m 644 "$INSTALL_DIR/microsoft.gpg" /usr/share/keyrings/microsoft.gpg
    rm -f "$INSTALL_DIR/microsoft.gpg"
    sudo tee /etc/apt/sources.list.d/vscode.sources > /dev/null <<EOF
Types: deb
URIs: https://packages.microsoft.com/repos/code
Suites: stable
Components: main
Architectures: amd64,arm64,armhf
Signed-By: /usr/share/keyrings/microsoft.gpg
EOF
    sudo apt update
    apt_install code
}

install_71() { # WineHQ Stable
    sudo mkdir -pm755 /etc/apt/keyrings
    wget -O - https://dl.winehq.org/wine-builds/winehq.key | sudo gpg --dearmor --yes -o /etc/apt/keyrings/winehq-archive.key -
    sudo dpkg --add-architecture i386
    sudo wget -NP /etc/apt/sources.list.d/ https://dl.winehq.org/wine-builds/debian/dists/trixie/winehq-trixie.sources
    sudo apt update
    apt_install winehq-stable
}

install_72() { apt_install wireshark; }                            # Wireshark
install_73() { apt_install xfce4-screensaver; }                    # XFCE4 Screen Saver
install_74() { apt_install xfce4-taskmanager; }                    # XFCE4 Task Manager

# ---------------------------------------------------------------------------
# Menu
# ---------------------------------------------------------------------------
show_menu() {
    # Arguments: IDs that should be pre-selected (used when returning via "Back")
    local preselected=" $* "
    local args=() i id name method state
    for i in "${!PROGRAMS[@]}"; do
        id=$(printf "%02d" $((i + 1)))
        name="${PROGRAMS[$i]%%|*}"
        method="${PROGRAMS[$i]##*|}"
        state="OFF"
        [[ "$preselected" == *" $id "* ]] && state="ON"
        args+=("$id" "$(printf '%-24s (%s)' "$name" "$method")" "$state")
    done

    whiptail --title "Program Installer" \
        --checklist "Use SPACE to select, TAB to move to the buttons, ENTER to confirm." \
        26 72 17 \
        --separate-output \
        "${args[@]}" 3>&1 1>&2 2>&3
}

# ---------------------------------------------------------------------------
# Main
# ---------------------------------------------------------------------------
main() {
    check_requirements

    local selection summary id idx name method
    SELECTED=()

    # Selection loop: "Back" on the confirmation screen returns to the menu
    # with the previous selection still checked.
    while true; do
        selection=$(show_menu "${SELECTED[@]}") || { echo "Cancelled."; exit 0; }

        if [ -z "$selection" ]; then
            whiptail --title "Program Installer" --msgbox "No program was selected." 8 40
            SELECTED=()
            continue
        fi

        mapfile -t SELECTED <<< "$selection"

        summary=""
        for id in "${SELECTED[@]}"; do
            idx=$((10#$id - 1))
            summary+="  ${id}) ${PROGRAMS[$idx]%%|*} (${PROGRAMS[$idx]##*|})"$'\n'
        done

        if whiptail --title "Confirm Installation" \
            --yes-button "Install" --no-button "Back" \
            --yesno "The following ${#SELECTED[@]} program(s) will be installed:\n\n${summary}\nInstall now, or go back to change the selection?" \
            24 64; then
            break
        fi
    done

    : > "$LOG_FILE"
    sudo -v || exit 1
    sudo apt update

    local succeeded=() failed=() rc
    for id in "${SELECTED[@]}"; do
        idx=$((10#$id - 1))
        name="${PROGRAMS[$idx]%%|*} (${PROGRAMS[$idx]##*|})"

        echo
        echo "=================================================="
        echo " [$id] Installing: $name"
        echo "=================================================="

        ( set -e; "install_${id}" ) 2>&1 | tee -a "$LOG_FILE"
        rc=${PIPESTATUS[0]}

        if [ "$rc" -eq 0 ]; then
            succeeded+=("$name")
        else
            failed+=("$name")
        fi
    done

    rm -rf "$INSTALL_DIR"

    local report="Installation finished.\n\nSucceeded: ${#succeeded[@]}\nFailed: ${#failed[@]}\n"
    if [ "${#failed[@]}" -gt 0 ]; then
        report+="\nFailed programs:\n"
        for name in "${failed[@]}"; do
            report+="  - ${name}\n"
        done
        report+="\nSee log: ${LOG_FILE}"
    fi
    whiptail --title "Program Installer" --msgbox "$report" 20 60
}

main "$@"
