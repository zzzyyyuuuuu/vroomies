{ config, pkgs, ... }:

{
  imports = [ ./hardware-configuration.nix ];

  # Bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Hostname
  networking.hostName = "vroomies";
  networking.networkmanager.enable = true;

  # Timezone — TODO: change to your timezone
  time.timeZone = "Europe/Istanbul";
  i18n.defaultLocale = "en_US.UTF-8";

  # GPU — uncomment your GPU
  # NVIDIA
  # services.xserver.videoDrivers = [ "nvidia" ];
  # hardware.nvidia.modesetting.enable = true;
  # hardware.nvidia.open = false;
  # hardware.opengl.enable = true;

  # AMD
  # hardware.opengl.enable = true;
  # hardware.opengl.driSupport = true;

  # Intel
  # hardware.opengl.enable = true;
  # hardware.opengl.extraPackages = with pkgs; [ intel-media-driver ];

  # Hyprland
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  # XDG Portals
  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-hyprland
      xdg-desktop-portal-gnome
    ];
  };

  # Audio
  sound.enable = true;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Fish shell
  programs.fish.enable = true;

  # Flatpak
  services.flatpak.enable = true;

  # Fonts
  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-emoji
  ];

  # User — TODO: change "user" to your username
  users.users.user = {
    isNormalUser = true;
    shell = pkgs.fish;
    extraGroups = [ "wheel" "networkmanager" "audio" "video" ];
  };

  # Allow unfree (nvidia etc.)
  nixpkgs.config.allowUnfree = true;

  # Flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  system.stateVersion = "25.05";
}
