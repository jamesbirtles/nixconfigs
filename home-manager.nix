{ config, pkgs, ... }:
{
  home-manager.useGlobalPkgs = true;
  home-manager.users.james = { pkgs, ... }: {
    home.stateVersion = "23.11";

    xdg.enable = true;

    programs.zsh = {
      enable = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;
    };
    programs.oh-my-posh = {
      enable = true;
      useTheme = "half-life";
    };
    programs.direnv = {
      enable = true;
      enableZshIntegration = true;
      nix-direnv.enable = true;
    };

    programs.wezterm = {
      enable = true;
      extraConfig = ''
        local wezterm = require("wezterm")

        local config = wezterm.config_builder()

        config.color_scheme = "Ayu Dark (Gogh)"
        config.font = wezterm.font("Berkeley Mono Variable")
        config.font_size = 12.0
        config.use_fancy_tab_bar = false
        config.hide_tab_bar_if_only_one_tab = true
        config.tab_bar_at_bottom = true

        return config
      '';
    };

    programs.git = {
      enable = true;
      userEmail = "james@birtles.dev";
      userName = "James Birtles";
      # TODO: re-enable
      # signing = {
      #   signByDefault = true;
      #   key = null;
      # };
      extraConfig = {
        push.autoSetupRemote = true;
        init.defaultBranch = "main";
      };
      ignores = [
        ".DS_Store"
        "Desktop.ini"
        ".Spotlight-V100"
        ".Trashes"
      ];
    };

    programs.lazygit = {
      enable = true;
      settings.gui.showFileTree = false;
    };
  };
}
