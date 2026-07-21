{ config, lib, pkgs, ... }:
{
  imports = [
    ./hardware.nix
    ../../modules/core
    ../../modules/features
    ../../modules/profiles/personal.nix
  ];

  networking.hostName = "jb-fwk16";

  # Share keyboard/mouse with the ThinkPad P16 sitting to the left.
  features.services.lan-mouse = {
    enable = true;
    peers = [
      {
        hostname = "jb-thinkpad-p16";
        position = "left";
      }
    ];
  };

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.initrd.systemd.enable = true;

  system.stateVersion = "24.05";
}
