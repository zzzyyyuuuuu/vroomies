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
    echo "Installing yay-bin - 'You're gonna carry that weight.' / Cowboy Bebop"
    echo "⚠️  WARNING: yay-bin is being installed from AUR. Make sure 'git' and 'base-devel' are available!"
    sudo pacman -S --needed base-devel git
    git clone https://aur.archlinux.org/yay-bin.git
    cd yay-bin && makepkg -si --noconfirm
    cd .. && rm -rf yay-bin
    AUR_HELPER="yay"
fi

official_pkgs=(
    'hyprland' 'swww' 'fastfetch' 'btop' 'fish' 'kitty' 'neovim' 
    'vlc' 'flatpak' 'pavucontrol' 'dolphin' 'qt6-declarative' 'qt6-quickcontrols2'
    'git' 'unzip' 'wget' 'lib32-mesa' 'vulkan-intel' 'intel-media-driver'
    'xdg-desktop-portal-hyprland' 'xdg-desktop-portal-gnome'
    'zoxide' 'starship'
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
echo "⚠️  WARNING: xdg-desktop-portal-hyprland and xdg-desktop-portal-gnome are being installed. If you have another portal active, conflicts may occur!"
sudo pacman -S --needed --noconfirm "${official_pkgs[@]}"

echo "AUR Packages - 'Let's gamble until we go mad!' / Kakegurui"
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

echo "Installing Papirus Icons - 'See you Space Cowboy... but first, let's make it pretty.' / Cowboy Bebop"
echo "⚠️  WARNING: Papirus-Dark will be copied to ~/.local/share/icons/. Existing Papirus-Dark folder will be overwritten if present!"
ICONS_DIR="$HOME/.local/share/icons"
if [ -d "/usr/share/icons/Papirus-Dark" ]; then
    mkdir -p "$ICONS_DIR"
    sudo cp -r /usr/share/icons/Papirus-Dark "$ICONS_DIR/"
    echo "✅ Papirus-Dark copied to $ICONS_DIR"
else
    echo "⚠️  WARNING: /usr/share/icons/Papirus-Dark not found! Make sure papirus-icon-theme installed correctly."
fi

echo "Setting Shell - 'To know sorrow is not terrifying. What is terrifying is to know you can't go back.' / Bleach"
if command -v fish &> /dev/null; then
    sudo chsh -s /usr/bin/fish "$USER"
    mkdir -p "$HOME/.config/fish"

    cat > "$HOME/.config/fish/config.fish" << 'EOF'
# --- SYSTEM ---
# --- SHORTCUTS ---
alias s="sudo pacman -S"
alias sy="sudo pacman -Syy"
alias y="sudo pacman -Syu"
alias r="sudo pacman -R"
alias yq="yay -Q"
alias ss="source ~/.config/fish/config.fish"
alias n="sudo nano"
alias f="fastfetch"
abbr -a -- v "wpctl set-volume @DEFAULT_AUDIO_SINK@ 1.0"
abbr -a -- c "cmatrix -b"
abbr -a -- cv "cava"
zoxide init fish | source
starship init fish | source
set fish_greeting

# History
set -U fish_history_path $HOME/.config/fish/fish_history
EOF

    echo "✅ config.fish written to $HOME/.config/fish/config.fish"
else
    echo "⚠️  WARNING: fish not found! Shell setup skipped."
fi

echo "Finish - 'See you space cowboy...' / Cowboy Bebop"
read -p "Reboot now? (y/n): " choice
if [[ "$choice" == "y" || "$choice" == "Y" ]]; then
    sudo reboot
fi
