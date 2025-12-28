{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.features.communication.slack;
in
{
  options.features.communication.slack = {
    enable = lib.mkEnableOption "Slack";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      slack
    ];
  };
}
