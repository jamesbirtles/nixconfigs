{ config, lib, pkgs, ... }:
{
  imports = [
    ./hardware.nix
    ../../modules/nixos/core
    ../../modules/nixos/features
    ../../modules/nixos/profiles/personal.nix
  ];

  networking.hostName = "jb-fwk16";

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  system.stateVersion = "24.05";
}
