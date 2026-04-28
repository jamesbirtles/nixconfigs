{ config, lib, pkgs, ... }:
{
  networking.networkmanager.enable = true;
  networking.networkmanager.dns = "systemd-resolved";

  networking.nftables.enable = true;

  services.resolved = {
    enable = true;
    settings.Resolve.DNSOverTLS = "opportunistic";
  };

  # Required for workerd to pick up local CA certificates
  environment.variables.SSL_CERT_FILE = "${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt";

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
