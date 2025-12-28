{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.features.apps.thunderbird;
in
{
  options.features.apps.thunderbird = {
    enable = lib.mkEnableOption "Thunderbird";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      thunderbird
    ];
  };
}
