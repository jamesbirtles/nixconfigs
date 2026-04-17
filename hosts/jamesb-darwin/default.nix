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

  networking.firewall.allowedTCPPorts = [ 4220 4500 ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  system.stateVersion = "25.11";
}
