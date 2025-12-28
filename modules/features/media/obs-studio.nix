{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.features.media.obs-studio;
in
{
  options.features.media.obs-studio = {
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
