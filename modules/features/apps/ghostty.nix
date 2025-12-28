{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.features.apps.ghostty;
in
{
  options.features.apps.ghostty = {
    enable = lib.mkEnableOption "Ghostty terminal emulator";
  };

  config = lib.mkIf cfg.enable {
    # Home-manager configuration for user james
    home-manager.users.james = {
      programs.ghostty = {
        enable = true;
        enableZshIntegration = true;
        settings = {
          keybind = [
            "alt+one=unbind"
            "alt+two=unbind"
            "alt+three=unbind"
            "alt+four=unbind"
            "alt+five=unbind"
            "alt+six=unbind"
            "alt+seven=unbind"
            "alt+eight=unbind"
            "alt+nine=unbind"
            "shift+enter=text:\\n"
          ];
          font-family = "BerkeleyMono Nerd Font";
          theme = "Ayu";
        };
      };
    };
  };
}
