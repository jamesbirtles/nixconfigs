{ config, lib, pkgs, ... }:
{
  imports = [
    ./hardware.nix
    ../../modules/nixos/core
    ../../modules/nixos/features
    ../../modules/nixos/profiles/work.nix
  ];

  networking.hostName = "jb-thinkpad-t16";

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  system.stateVersion = "25.11";
}
