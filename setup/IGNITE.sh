#!/bin/bash

# vroomies  Fedora Power-User Setup

set -e

echo "Starting - 'Whatever happens, happens.' / Cowboy Bebop"
if command -v dnf &> /dev/null; then
    PACKAGE_MANAGER="sudo dnf"
else
    echo "Wrong OS! - 'Omae wa mou shindeiru.' / Hokuto no Ken"
    exit 1
fi

official_pkgs=(
    'hyprland' 'swww' 'fastfetch' 'btop' 'fish' 'kitty' 'neovim' 
    'vlc' 'flatpak' 'pavucontrol' 'dolphin' 'qt6-qtdeclarative' 'qt6-qtquickcontrols2'
    'git' 'unzip' 'wget' 'mesa-va-drivers' 'intel-media-driver'
)

echo "System Update - 'Domain Expansion: Infinite Void.' / Jujutsu Kaisen"
$PACKAGE_MANAGER update -y

GPU=$(lspci | grep -iE 'vga|3d')

if [[ $GPU == *"NVIDIA"* ]]; then
    echo "NVIDIA Drivers - 'Power is not will, it is the phenomenon of physically making things happen.' / High School DxD"
    $PACKAGE_MANAGER install -y akmod-nvidia xorg-x11-drv-nvidia-cuda
elif [[ $GPU == *"AMD"* ]]; then
    echo "AMD Drivers - 'The world is not perfect.' / Fullmetal Alchemist"
    $PACKAGE_MANAGER install -y xorg-x11-drv-amdgpu mesa-dri-drivers
fi

echo "Official Packages - 'I'll take a potato chip... and EAT IT!' / Death Note"
$PACKAGE_MANAGER install -y "${official_pkgs[@]}"

echo "Flatpaks - 'I am the God of the new world!' / Death Note"
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

echo "Deploying Fonts - 'The future is something that you build yourself.' / High School DxD"
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
