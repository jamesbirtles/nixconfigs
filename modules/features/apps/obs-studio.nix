{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.features.apps.obs-studio;
in
{
  options.features.apps.obs-studio = {
    enable = lib.mkEnableOption "OBS Studio for screen recording and streaming";
  };

  config = lib.mkIf cfg.enable {
    # Home-manager configuration for user james
    home-manager.users.james = {
      programs.obs-studio = {
        enable = true;
      };
    };
  };
}
