{ config, pkgs, outPath, ... }:
{
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "jb-fwk13"; 

  system.stateVersion = "25.05";
}
