{ config, lib, pkgs, ... }:
{
  networking.networkmanager.enable = true;
  networking.networkmanager.dns = "systemd-resolved";

  networking.nftables.enable = true;

  services.resolved = {
    enable = true;
    settings.Resolve.DNSOverTLS = "opportunistic";
  };

  boot.kernel.sysctl."net.ipv4.ip_unprivileged_port_start" = 80;

  # Required for workerd to pick up local CA certificates
  environment.variables.SSL_CERT_FILE = "${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt";

  environment.systemPackages = [ pkgs.iperf3 ];

  services.iperf3 = {
    enable = true;
    openFirewall = true;
  };

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
