#!/bin/sh

# Experimental installer made by OT1
# CachyOS minimal + Hyprland + Caelestia

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
    sudo pacman -S --needed git curl wget base-devel gcc fastfetch htop btop nvtop vim nano fish rustup
}

# ---------------------------
# FONTS
# ---------------------------
cacheFonts () {
    fc-cache -fv
}

installFonts () {
    sudo pacman -S --needed ttf-jetbrains-mono-nerd noto-fonts-emoji ttf-font-awesome

    cacheFonts
}

# ---------------------------
# BLUETOOTH
# ---------------------------
installBluetooth () {
    sudo pacman -S --needed bluez bluez-utils
    sudo systemctl enable bluetooth
}

# ---------------------------
# DISPLAY MANAGER (optional)
# ---------------------------
installSDDM () {
    sudo pacman -S --needed sddm
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
    paru -S caelestia-cli

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

    installBrowsers
    installGraphics

    installCaelestia

    echo "-------------------------------------"
    echo "[DONE] System installed successfully"
    echo "-------------------------------------"
    echo 
    echo "Now do sudo systemctl start sddm to start your enviroment"
}

programa
