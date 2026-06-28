#!/bin/sh

# Instalador experimental hecho por OT
# CachyOS minimal + Hyprland + Caelestia

set -e

cachyOSURL="cachyos.org"
paruURL="https://aur.archlinux.org/paru.git"

basePathUser="$HOME"
paruPath="$HOME/paru"

# ---------------------------
# INTERNET CHECK
# ---------------------------
testWifi () {
    echo "[INFO] Checking internet..."

    if ! ping -c 3 "$cachyOSURL" >/dev/null 2>&1; then
        echo "[ERROR] No internet connection"
        exit 1
    fi

    echo "[OK] Internet connection"
}

# ---------------------------
# SYSTEM UPDATE
# ---------------------------
systemUpdate () {
    sudo pacman -Syyu
}

# ---------------------------
# BASE TOOLS
# ---------------------------
installBaseTools () {
    sudo pacman -S --needed git curl wget base-devel cmake make gcc perl fastfetch htop btop nvtop vim nano fish rustup
}

# ---------------------------
# FONTS
# ---------------------------
cacheFonts () {
    fc-cache -fv
}

installFonts () {
    sudo pacman -S --needed ttf-jetbrains-mono-nerd noto-fonts-emoji ttf-font-awesome ttf-material-design-icons-git

    cacheFonts
}

# ---------------------------
# BLUETOOTH
# ---------------------------
installBluetooth () {
    sudo pacman -S --needed --noconfirm bluez bluez-utils
    sudo systemctl enable bluetooth
}

# ---------------------------
# DISPLAY MANAGER (optional)
# ---------------------------
installSDDM () {
    sudo pacman -S --needed --noconfirm sddm
    sudo systemctl enable sddm
}

# ---------------------------
# PARU
# ---------------------------
setupParu () {
    sudo pacman -S --needed base-devel rustup fish
    rustup default stable
}

installParu () {
    echo "[INFO] Installing paru..."

    cd "$basePathUser"
    rm -rf paru

    git clone "$paruURL" "$paruPath"
    cd "$paruPath"

    makepkg -si

    cd "$basePathUser"
}

# ---------------------------
# CAELESTIA
# ---------------------------
installCaelestia () {
    paru -S caelestia

    caelestia install --disable-components firefox,spotify,vscodium,vscode,discord,todoist
}

# ---------------------------
# BROWSERS (IMPORTANT FIX)
# ---------------------------
installBrowsers () {
    paru -S librewolf-bin zen-browser-bin
}

# ---------------------------
# GRAPHICS
# ---------------------------
installGraphics () {
    sudo pacman -S --needed vulkan-headers vulkan-icd-loader python-gobject dart-sass
}

# ---------------------------
# CORE EXECUTION
# ---------------------------
programa () {

    testWifi

    systemUpdate

    installBaseTools
    installFonts

    installBluetooth
    installSDDM

    setupParu
    installParu

    installCaelestia
    installBrowsers

    installGraphics
    echo "-------------------------------------"
    echo "[DONE] System installed successfully"
    echo "-------------------------------------"
    echo "Now do sudo systemctl start sddm to start your enviroment"
}

programa