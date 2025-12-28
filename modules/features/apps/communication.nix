{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.features.apps.communication;
in
{
  options.features.apps.communication = {
    enable = lib.mkEnableOption "Communication applications";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      thunderbird
      slack
      discord
    ];
  };
}
