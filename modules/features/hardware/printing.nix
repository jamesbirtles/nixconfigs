{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.features.hardware.printing;
in
{
  options.features.hardware.printing = {
    enable = lib.mkEnableOption "CUPS printing support";
  };

  config = lib.mkIf cfg.enable {
    services.printing.enable = true;
  };
}
