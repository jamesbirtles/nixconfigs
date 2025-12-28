{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.features.security.vpn;
in
{
  options.features.security.vpn = {
    enable = lib.mkEnableOption "VPN client applications";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      protonvpn-gui
      openconnect
    ];
  };
}
