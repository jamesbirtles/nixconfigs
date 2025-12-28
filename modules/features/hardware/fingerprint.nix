{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.features.hardware.fingerprint;
in
{
  options.features.hardware.fingerprint = {
    enable = lib.mkEnableOption "Fingerprint reader support";
  };

  config = lib.mkIf cfg.enable {
    services.fprintd.enable = true;
  };
}
