{
  config,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    ./server.nix
  ];

  # Work-specific features on top of the server base
  features = {
    development.docker.enable = lib.mkDefault true;
    development.cloud-tools.enable = lib.mkDefault true;

    terminal.claude-code.enable = lib.mkDefault true;

    security.vpn.enable = lib.mkDefault true;

    services.lldpd.enable = lib.mkDefault true;

    development.techex.enable = lib.mkDefault true;
  };
}
