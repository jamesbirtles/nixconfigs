{ config, pkgs, ... }:
{
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.initrd.luks.devices."luks-a48122fc-9424-4da0-99c6-a0180a322bc2".device = "/dev/disk/by-uuid/a48122fc-9424-4da0-99c6-a0180a322bc2";
  networking.hostName = "jb-fwk16";

  users.users.james = {
    isNormalUser = true;
    description = "James Birtles";
    extraGroups = [ "networkmanager" "wheel" "docker" ];
    packages = with pkgs; [
      bitwarden-desktop
      chromium
    ];
  };

  programs.steam.enable = true;

  environment.systemPackages = with pkgs; [
    mangohud
    gamemode
  ];

  system.stateVersion = "24.05";
}
