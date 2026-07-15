{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.features.communication.teams-for-linux;
in
{
  options.features.communication.teams-for-linux = {
    enable = lib.mkEnableOption "Teams for Linux";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      teams-for-linux
    ];
  };
}
