# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.initrd.luks.devices."luks-caf0a56f-856c-4415-a635-88c3a05e141a".device = "/dev/disk/by-uuid/caf0a56f-856c-4415-a635-88c3a05e141a";
  networking.hostName = "jb-fwk13-execify"; 

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.displayManager.gdm.wayland = true;
  services.xserver.desktopManager.gnome.enable = true;

  users.users.james = {
    isNormalUser = true;
    description = "James Birtles";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
      bitwarden-desktop
      chromium
    ];
  };

  system.stateVersion = "24.05";
}
