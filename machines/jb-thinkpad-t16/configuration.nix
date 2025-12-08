{ config, pkgs, outPath, ... }:
{
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "jb-thinkpad-t16"; 

  system.stateVersion = "25.11";
}
