{ config, lib, pkgs, ... }:
{
  networking.networkmanager.enable = true;

  networking.firewall.allowedTCPPortRanges = [
    {
      from = 8070;
      to = 8090;
    }
  ];

  networking.firewall.allowedUDPPortRanges = [
    {
      from = 8070;
      to = 8090;
    }
  ];
}
