{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.features.gaming.steam;
in
{
  options.features.gaming.steam = {
    enable = lib.mkEnableOption "Steam gaming platform";
  };

  config = lib.mkIf cfg.enable {
    programs.steam.enable = true;

    environment.systemPackages = with pkgs; [
      protonup-qt
    ];
  };
}
