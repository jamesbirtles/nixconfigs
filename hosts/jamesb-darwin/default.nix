{
  ...
}:
{
  imports = [
    ./hardware.nix
    ../../modules/core
    ../../modules/features
    ../../modules/profiles/work-server.nix
  ];

  networking.hostName = "jamesb-darwin";

  networking.firewall.allowedTCPPorts = [ 4221 4500 5349 ];
  networking.firewall.allowedUDPPorts = [ 3478 5349 ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.initrd.systemd.enable = true;

  system.stateVersion = "25.11";
}
