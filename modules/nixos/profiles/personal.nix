{ config, lib, pkgs, ... }:
{
  # Personal machines - enable everything including gaming
  features = {
    desktop.gnome.enable = lib.mkDefault true;
    desktop.niri.enable = lib.mkDefault true;
    gaming.steam.enable = lib.mkDefault true;
    gaming.performance.enable = lib.mkDefault true;
    development.docker.enable = lib.mkDefault true;
    hardware.audio.enable = lib.mkDefault true;
    hardware.printing.enable = lib.mkDefault true;
    hardware.fingerprint.enable = lib.mkDefault true;
    hardware.fwupd.enable = lib.mkDefault true;
    security.onepassword.enable = lib.mkDefault true;
    media.apps.enable = lib.mkDefault true;
    services.flatpak.enable = lib.mkDefault true;
    services.rclone-mount.enable = lib.mkDefault true;
  };
}
