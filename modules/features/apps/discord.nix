{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.features.apps.discord;
in
{
  options.features.apps.discord = {
    enable = lib.mkEnableOption "Discord";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      discord
    ];
  };
}
