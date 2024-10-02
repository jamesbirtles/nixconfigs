{ config, pkgs, ... }:
{
  nix.settings.trusted-users = [ "root" "@wheel" ];

  boot.kernelPackages = pkgs.linuxPackages_6_11;

  networking.networkmanager.enable = true;

  time.timeZone = "Europe/London";
  i18n.defaultLocale = "en_GB.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_GB.UTF-8";
    LC_IDENTIFICATION = "en_GB.UTF-8";
    LC_MEASUREMENT = "en_GB.UTF-8";
    LC_MONETARY = "en_GB.UTF-8";
    LC_NAME = "en_GB.UTF-8";
    LC_NUMERIC = "en_GB.UTF-8";
    LC_PAPER = "en_GB.UTF-8";
    LC_TELEPHONE = "en_GB.UTF-8";
    LC_TIME = "en_GB.UTF-8";
  };

  services.xserver.enable = true;
  services.xserver.xkb = {
    layout = "gb";
    variant = "";
  };

  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.displayManager.gdm.wayland = true;
  services.xserver.desktopManager.gnome.enable = true;

  services.printing.enable = true;
  services.fwupd.enable = true;
  services.fprintd.enable = true;

  virtualisation.docker.enable = true;

  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  console.keyMap = "uk";
  users.defaultUserShell = pkgs.zsh;

  programs.nix-ld.enable = true;
  programs.chromium.enable = true;
  programs.steam.enable = true;

  fonts.fontDir.enable = true;

  environment.systemPackages = with pkgs; [
    wl-clipboard-rs
    dconf2nix
    mangohud
    gamemode
    bitwarden-desktop
    gnomeExtensions.appindicator
    gnome-tweaks
  ];
  services.udev.packages = [ pkgs.gnome-settings-daemon ];

  security.polkit.enable = true;

  # Allows zoom to find xdg-desktop-portal to allow for screensharing
  systemd.tmpfiles.rules = [
    "L+ /usr/libexec/xdg-desktop-portal - - - - ${pkgs.xdg-desktop-portal}/libexec/xdg-desktop-portal"
  ];
}
