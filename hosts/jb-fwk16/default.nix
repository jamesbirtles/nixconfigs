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
        fingerprint = "d3:34:23:3a:45:54:92:c2:9b:69:75:d8:c0:dd:cb:61:7d:ad:d2:61:c7:de:09:4b:e2:13:58:ee:a7:61:53:be";
      }
    ];
  };

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.initrd.systemd.enable = true;

  system.stateVersion = "24.05";
}
