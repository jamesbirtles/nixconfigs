{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.features.communication.discord;
in
{
  options.features.communication.discord = {
    enable = lib.mkEnableOption "Discord";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      discord
    ];
  };
}
