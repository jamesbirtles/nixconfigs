{ config, lib, pkgs, ... }:
{
  imports = [
    # Desktop
    ./desktop/gnome.nix
    ./desktop/niri

    # Gaming
    ./gaming/steam.nix
    ./gaming/performance.nix

    # Development
    ./development/docker.nix

    # Hardware
    ./hardware/audio.nix
    ./hardware/printing.nix
    ./hardware/fingerprint.nix
    ./hardware/fwupd.nix

    # Security
    ./security/onepassword.nix

    # Media
    ./media/apps.nix

    # Services
    ./services/flatpak.nix
    ./services/rclone-mount.nix
  ];
}
