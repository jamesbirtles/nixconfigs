{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.features.services.lldpd;
in
{
  options.features.services.lldpd = {
    enable = lib.mkEnableOption "LLDP daemon for link layer discovery";
  };

  config = lib.mkIf cfg.enable {
    services.lldpd.enable = true;
    users.users.james.extraGroups = [ "_lldpd" ];
    environment.systemPackages = [ pkgs.lldpd ];
  };
}
