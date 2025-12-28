{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.features.gaming.performance;
in
{
  options.features.gaming.performance = {
    enable = lib.mkEnableOption "Gaming performance optimizations (gamemode, mangohud)";
  };

  config = lib.mkIf cfg.enable {
    programs.gamemode.enable = true;

    environment.systemPackages = with pkgs; [
      mangohud
    ];
  };
}
