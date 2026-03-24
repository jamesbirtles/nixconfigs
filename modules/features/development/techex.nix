{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.features.development.techex;
in
{
  options.features.development.techex = {
    enable = lib.mkEnableOption "Techex-specific development tools";
  };

  config = lib.mkIf cfg.enable {
    security.wrappers.dmidecode = {
      source = "${pkgs.dmidecode}/bin/dmidecode";
      capabilities = "cap_sys_rawio,cap_dac_override+ep";
      owner = "root";
      group = "root";
    };
  };
}
