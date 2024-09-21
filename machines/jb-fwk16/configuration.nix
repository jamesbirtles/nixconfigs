{ config, pkgs, ... }:
{
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.initrd.luks.devices."luks-a48122fc-9424-4da0-99c6-a0180a322bc2".device = "/dev/disk/by-uuid/a48122fc-9424-4da0-99c6-a0180a322bc2";
  networking.hostName = "jb-fwk16";

  system.stateVersion = "24.05";
}
