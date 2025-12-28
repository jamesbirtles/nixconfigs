{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.features.hardware.fwupd;
in
{
  options.features.hardware.fwupd = {
    enable = lib.mkEnableOption "Firmware update daemon";
  };

  config = lib.mkIf cfg.enable {
    services.fwupd.enable = true;
  };
}
