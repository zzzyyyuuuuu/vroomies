#!/bin/bash

# Vroomies Arch Linux / Arch-Based Ultimate Setup

set -e

echo "Detecting AUR Helper - 'Whatever happens, happens.' / Cowboy Bebop"
if command -v yay &> /dev/null; then
    AUR_HELPER="yay"
elif command -v paru &> /dev/null; then
    AUR_HELPER="paru"
elif command -v trizen &> /dev/null; then
    AUR_HELPER="trizen"
else
    echo "Installing yay - 'I'll start from zero!' / Re:Zero"
    sudo pacman -S --needed base-devel git
    git clone https://aur.archlinux.org/yay.git
    cd yay && makepkg -si --noconfirm
    cd .. && rm -rf yay
    AUR_HELPER="yay"
fi

official_pkgs=(
    'hyprland' 'swww' 'fastfetch' 'btop' 'fish' 'kitty' 'neovim' 
    'vlc' 'flatpak' 'pavucontrol' 'dolphin' 'qt6-declarative' 'qt6-quickcontrols2'
    'git' 'unzip' 'wget' 'lib32-mesa' 'vulkan-intel' 'intel-media-driver'
)

aur_pkgs=(
    'quickshell-git' 'matugen-bin' 'papirus-icon-theme' 
    'papirus-folders-git' 'bibata-cursor-theme-bin'
)

echo "Updating System - 'Domain Expansion: Infinite Void.' / Jujutsu Kaisen"
sudo pacman -Syu --noconfirm

GPU=$(lspci | grep -iE 'vga|3d')

if [[ $GPU == *"NVIDIA"* ]]; then
    echo "Installing NVIDIA - 'Power is not will, it is the phenomenon of physically making things happen.' / High School DxD"
    sudo pacman -S --noconfirm nvidia-dkms nvidia-utils lib32-nvidia-utils nvidia-settings
elif [[ $GPU == *"AMD"* ]]; then
    echo "Installing AMD - 'The future is something that you build yourself.' / High School DxD"
    sudo pacman -S --noconfirm xf86-video-amdgpu mesa lib32-mesa vulkan-radeon lib32-vulkan-radeon
fi

echo "Official Packages - 'I'll take a potato chip... and EAT IT!' / Death Note"
sudo pacman -S --needed --noconfirm "${official_pkgs[@]}"

echo "AUR Packages - 'Let’s gamble until we go mad!' / Kakegurui"
$AUR_HELPER -S --needed --noconfirm "${aur_pkgs[@]}"

echo "Flatpak Apps - 'I am the God of the new world!' / Death Note"
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
flatpak install -y flathub com.discordapp.Discord org.localsend.LocalSend com.obsproject.Studio

echo "Linking Configs - 'Fear is necessary for evolution.' / Bleach"
if [ ! -d "$HOME/.config" ]; then
    mkdir -p "$HOME/.config"
fi

[ -d "$HOME/vroomies/hypr" ] && ln -sf "$HOME/vroomies/hypr" "$HOME/.config/"
[ -d "$HOME/vroomies/quickshell" ] && ln -sf "$HOME/vroomies/quickshell" "$HOME/.config/"

if [ -d "./settings" ]; then
    cp -r ./settings/* "$HOME/.config/"
fi

echo "Capturing Visions - 'No matter what happens, keep moving forward.' / Jujutsu Kaisen"
if [ ! -d "$HOME/Pictures" ]; then
    mkdir -p "$HOME/Pictures"
fi

if [ -d "./visions" ]; then
    cp -rf "./visions" "$HOME/Pictures/"
fi

echo "Deploying Fonts - 'The world is not perfect.' / Fullmetal Alchemist"
FONT_DIR="$HOME/.local/share/fonts"
if [ -d "$HOME/vroomies/fonts" ]; then
    [ ! -d "$FONT_DIR" ] && mkdir -p "$FONT_DIR"
    cp -rf "$HOME/vroomies/fonts/"* "$FONT_DIR/"
    fc-cache -fv
fi

echo "Setting Shell - 'To know sorrow is not terrifying. What is terrifying is to know you can't go back.' / Bleach"
if command -v fish &> /dev/null; then
    sudo chsh -s /usr/bin/fish "$USER"
    mkdir -p "$HOME/.config/fish"
    echo "fish_add_path \$HOME/.cargo/bin" >> "$HOME/.config/fish/config.fish"
fi

echo "Finish - 'See you space cowboy...' / Cowboy Bebop"
read -p "Reboot now? (y/n): " choice
if [[ "$choice" == "y" || "$choice" == "Y" ]]; then
    sudo reboot
fi
