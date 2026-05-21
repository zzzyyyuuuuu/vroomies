#!/bin/bash
# Vroomies NixOS + Home Manager Setup
set -e

echo "Starting EDEN - 'Whatever happens, happens.' / Cowboy Bebop"

# Check NixOS
if [ ! -f /etc/nixos/configuration.nix ]; then
    echo "Wrong OS! - 'Omae wa mou shindeiru.' / Hokuto no Ken"
    exit 1
fi

CURRENT_USER="$USER"
NIXOS_DIR="/etc/nixos"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
NIX_SRC="$SCRIPT_DIR/../nix"

echo "Detected user: $CURRENT_USER - 'I am the one who chooses their own path.' / Steins;Gate"

# Enable flakes if not already
echo "Enabling Flakes - 'Domain Expansion: Infinite Void.' / Jujutsu Kaisen"
if ! grep -q "experimental-features" /etc/nix/nix.conf 2>/dev/null; then
    sudo mkdir -p /etc/nix
    echo "experimental-features = nix-command flakes" | sudo tee -a /etc/nix/nix.conf
    echo "✅ Flakes enabled"
else
    echo "✅ Flakes already enabled"
fi

# Backup existing nixos config
echo "Backing up existing config - 'Fear is necessary for evolution.' / Bleach"
BACKUP_DIR="$HOME/nixos-backup-$(date +%Y%m%d%H%M%S)"
sudo cp -r "$NIXOS_DIR" "$BACKUP_DIR"
echo "✅ Backup saved to $BACKUP_DIR"

# Copy nix files
echo "Copying EDEN configs - 'No matter what happens, keep moving forward.' / Jujutsu Kaisen"
echo "⚠️  WARNING: flake.nix, configuration.nix and home.nix will be copied to $NIXOS_DIR. Existing files will be overwritten!"
sudo cp "$NIX_SRC/flake.nix" "$NIXOS_DIR/flake.nix"
sudo cp "$NIX_SRC/configuration.nix" "$NIXOS_DIR/configuration.nix"
sudo cp "$NIX_SRC/home.nix" "$NIXOS_DIR/home.nix"

# Replace "user" with actual username
echo "Configuring for user '$CURRENT_USER' - 'I'll start from zero!' / Re:Zero"
sudo sed -i "s/\"user\"/\"$CURRENT_USER\"/g" "$NIXOS_DIR/flake.nix"
sudo sed -i "s/\"user\"/\"$CURRENT_USER\"/g" "$NIXOS_DIR/configuration.nix"
sudo sed -i "s/\/home\/user/\/home\/$CURRENT_USER/g" "$NIXOS_DIR/home.nix"
sudo sed -i "s/users\.$CURRENT_USER/users.$CURRENT_USER/g" "$NIXOS_DIR/home.nix"
sudo sed -i "s/home-manager\.users\.user/home-manager.users.$CURRENT_USER/g" "$NIXOS_DIR/flake.nix"
echo "✅ Username set to '$CURRENT_USER'"

# Detect GPU
echo "Detecting GPU - 'Power is not will, it is the phenomenon of physically making things happen.' / High School DxD"
GPU=$(lspci | grep -iE 'vga|3d')
if [[ $GPU == *"NVIDIA"* ]]; then
    echo "NVIDIA detected — uncommenting NVIDIA config"
    sudo sed -i 's/# services.xserver.videoDrivers/services.xserver.videoDrivers/' "$NIXOS_DIR/configuration.nix"
    sudo sed -i 's/# hardware.nvidia.modesetting/hardware.nvidia.modesetting/' "$NIXOS_DIR/configuration.nix"
    sudo sed -i 's/# hardware.nvidia.open/hardware.nvidia.open/' "$NIXOS_DIR/configuration.nix"
    sudo sed -i '/# NVIDIA/{n;s/# //}' "$NIXOS_DIR/configuration.nix"
elif [[ $GPU == *"AMD"* ]]; then
    echo "AMD detected — uncommenting AMD config"
    sudo sed -i '/# AMD/{n;s/# //;n;s/# //}' "$NIXOS_DIR/configuration.nix"
elif [[ $GPU == *"Intel"* ]]; then
    echo "Intel detected — uncommenting Intel config"
    sudo sed -i '/# Intel/{n;s/# //;n;s/# //}' "$NIXOS_DIR/configuration.nix"
fi
echo "✅ GPU configured"

# Flatpak setup
echo "Setting up Flatpak - 'I am the God of the new world!' / Death Note"
nix-env -iA nixos.flatpak 2>/dev/null || true
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
flatpak install -y flathub com.discordapp.Discord org.localsend.LocalSend com.obsproject.Studio

# nixos-rebuild
echo "Building EDEN - 'You're gonna carry that weight.' / Cowboy Bebop"
echo "⚠️  WARNING: This will run nixos-rebuild switch. Your system config will change!"
read -p "Continue? (y/n): " confirm
if [[ "$confirm" != "y" && "$confirm" != "Y" ]]; then
    echo "Aborted. Your backup is at $BACKUP_DIR"
    exit 0
fi

sudo nixos-rebuild switch --flake "$NIXOS_DIR#vroomies"

echo "Finish - 'See you space cowboy...' / Cowboy Bebop"
read -p "Reboot now? (y/n): " choice
if [[ "$choice" == "y" || "$choice" == "Y" ]]; then
    sudo reboot
fi
