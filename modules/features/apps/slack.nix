{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.features.apps.slack;
in
{
  options.features.apps.slack = {
    enable = lib.mkEnableOption "Slack";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      slack
    ];
  };
}
