{
  ...
}:
{
  imports = [
    ./hardware.nix
    ../../modules/core
    ../../modules/features
    ../../modules/profiles/server.nix
  ];

  networking.hostName = "jamesbox";

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.initrd.systemd.enable = true;

  system.stateVersion = "25.11";
}
