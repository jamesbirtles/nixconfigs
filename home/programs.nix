# Common programs used across platforms
{ pkgs, lib, ... }:
{
  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
    "raycast"
    "discord"
  ];
  home-manager.users.james = {
    home.packages = with pkgs; [
      discord
    ];

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

    programs.alacritty = {
      enable = true;
      settings = {
        import = [ "${pkgs.alacritty-theme}/ayu_dark.toml" ];
        window = {
          opacity = 1;
          blur = true;
        };
        font = {
          size = lib.mkDefault 13;
        };
        colors = {
          transparent_background_colors = true;
        };
      };
    };

    programs.git = {
      enable = true;
      userEmail = "james@birtles.dev";
      userName = "James Birtles";
      signing = {
        signByDefault = true;
        key = null;
      };
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

