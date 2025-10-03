{ config, pkgs, outPath, ... }:
{
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.initrd.luks.devices."luks-caf0a56f-856c-4415-a635-88c3a05e141a".device = "/dev/disk/by-uuid/caf0a56f-856c-4415-a635-88c3a05e141a";
  networking.hostName = "jb-fwk13"; 

  system.stateVersion = "24.05";
}
