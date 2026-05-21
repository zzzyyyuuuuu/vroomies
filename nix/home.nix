{ config, pkgs, ... }:

{
  # TODO: change "user" and "/home/user" to your username
  home.username = "user";
  home.homeDirectory = "/home/user";
  home.stateVersion = "25.05";

  # Packages
  home.packages = with pkgs; [
    # Core
    swww
    fastfetch
    btop
    kitty
    neovim
    vlc
    pavucontrol
    dolphin
    # Quickshell
    quickshell
    # Icons
    papirus-icon-theme
    # Cursor
    bibata-cursors
    # Utils
    unzip
    wget
    # Media
    cava
    cmatrix
    wireplumber
  ];

  # Fish
  programs.fish = {
    enable = true;
    shellAliases = {
      s   = "sudo nix-env -iA";
      sy  = "sudo nixos-rebuild dry-run --flake /etc/nixos#vroomies";
      y   = "sudo nixos-rebuild switch --flake /etc/nixos#vroomies";
      r   = "sudo nix-env -e";
      yq  = "nix-env -q";
      ss  = "source ~/.config/fish/config.fish";
      n   = "sudo nano";
      f   = "fastfetch";
    };
    shellAbbrs = {
      v  = "wpctl set-volume @DEFAULT_AUDIO_SINK@ 1.0";
      c  = "cmatrix -b";
      cv = "cava";
    };
    interactiveShellInit = ''
      set fish_greeting
      set -U fish_history_path $HOME/.config/fish/fish_history
    '';
  };

  # Starship
  programs.starship = {
    enable = true;
    enableFishIntegration = true;
  };

  # Zoxide
  programs.zoxide = {
    enable = true;
    enableFishIntegration = true;
  };

  # Kitty
  programs.kitty = {
    enable = true;
    settings = {
      confirm_os_window_close = 0;
      enable_audio_bell = false;
    };
  };

  # Symlink vroomies configs
  home.file = {
    ".config/hypr".source = ../hypr;
    ".config/quickshell".source = ../quickshell;
  };

  # Wallpapers
  home.file."Pictures/visions".source = ../visions;

  # Fonts
  home.file.".local/share/fonts".source = ../fonts;

  # Papirus-Dark to local icons
  home.file.".local/share/icons/Papirus-Dark" = {
    source = "${pkgs.papirus-icon-theme}/share/icons/Papirus-Dark";
    recursive = true;
  };

  programs.home-manager.enable = true;
}
