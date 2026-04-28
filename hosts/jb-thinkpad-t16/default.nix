{ config, lib, pkgs, ... }:
{
  imports = [
    ./hardware.nix
    ../../modules/core
    ../../modules/features
    ../../modules/profiles/work.nix
  ];

  networking.hostName = "jb-thinkpad-t16";

  features.hardware.fingerprint.enable = false;

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.initrd.systemd.enable = true;

  system.stateVersion = "25.11";
}
