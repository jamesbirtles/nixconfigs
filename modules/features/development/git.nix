{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.features.development.git;
in
{
  options.features.development.git = {
    enable = lib.mkEnableOption "Git with GitHub CLI and lazygit";
  };

  config = lib.mkIf cfg.enable {
    # Home-manager configuration for user james
    home-manager.users.james = {
      programs.git = {
        enable = true;
        signing = {
          signByDefault = true;
          format = "ssh";
          signer = "${pkgs._1password-gui}/bin/op-ssh-sign";
          key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOvUudGnuBJItRUSZen7D4Emkh1ZCA4C1t93Ke4A1yFr";
        };
        settings = {
          user.email = "james@birtles.dev";
          user.name = "James Birtles";
          push.autoSetupRemote = true;
          init.defaultBranch = "main";
        };
        ignores = [
          ".DS_Store"
          "Desktop.ini"
          ".Spotlight-V100"
          ".Trashes"
        ];
        lfs.enable = true;
      };

      programs.gh = {
        enable = true;
        settings = {
          git_protocol = "ssh";
        };
        extensions = with pkgs; [ gh-notify ];
      };

      programs.lazygit = {
        enable = true;
        settings.gui = {
          showFileTree = false;
          nerdFontsVersion = "3";
          theme.selectedLineBgColor = [ "reverse" ];
        };
      };
    };
  };
}
