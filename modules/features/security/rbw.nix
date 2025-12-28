{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.features.security.rbw;
in
{
  options.features.security.rbw = {
    enable = lib.mkEnableOption "rbw (Bitwarden CLI)";
  };

  config = lib.mkIf cfg.enable {
    # Home-manager configuration for user james
    home-manager.users.james = {
      programs.rbw = {
        enable = true;
        settings.email = "jameshbirtles@gmail.com";
        settings.pinentry = pkgs.pinentry-gnome3;
      };
    };
  };
}
