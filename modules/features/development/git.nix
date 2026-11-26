{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.features.development.git;
  lazygitDir = "${config.home-manager.users.james.xdg.configHome}/lazygit";
in
{
  options.features.development.git = {
    enable = lib.mkEnableOption "Git with GitHub CLI and lazygit";
  };

  config = lib.mkIf cfg.enable {
    # config.yml is a read-only store symlink, so Noctalia's lazygit hook
    # can't merge its theme in. Layer the generated theme file on top instead
    # (later files win).
    environment.sessionVariables.LG_CONFIG_FILE = "${lazygitDir}/config.yml,${lazygitDir}/themes/noctalia.yml";

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
          rebase.updateRefs = true;
        };
        ignores = [
          ".DS_Store"
          "Desktop.ini"
          ".Spotlight-V100"
          ".Trashes"
          ".zed/"
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
        };
      };

      programs.claude-code = lib.mkIf config.features.terminal.claude-code.enable {
        settings.permissions.allow = [
          "Bash(git status:*)"
          "Bash(git diff:*)"
          "Bash(git log:*)"
          "Bash(git branch:*)"
          "Bash(git show:*)"
          "Bash(git blame:*)"
          "Bash(git rev-parse:*)"
          "Bash(git add:*)"
        ];
      };
    };
  };
}
