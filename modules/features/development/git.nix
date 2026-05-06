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
      home.packages = with pkgs; [ git-bug ];

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
          theme.selectedLineBgColor = [ "reverse" ];
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
          "Bash(git bug:*)"
        ];
        context = ''

          ## Issue tracking

          For tracking issues within a repo, use `git bug` unless the project specifies another tracker (e.g. GitHub Issues, Linear). Bugs are stored as git objects in the repo itself.

          Common commands:

              $ git bug bug                              # list open bugs
              $ git bug bug --status closed              # list closed bugs
              $ git bug bug new -t "title" -m "body"     # create a bug
              $ git bug bug show <id>                    # view a bug (id can be a prefix)
              $ git bug bug comment new <id> -m "text"   # add a comment
              $ git bug bug status close <id>            # close a bug
              $ git bug bug status open <id>             # reopen a bug
              $ git bug bug label new <id> <label>       # add a label

          Run `git bug commands` to list every subcommand, or `git bug <subcommand> --help` for details.

          If a command fails with "No identity is set", create one before retrying. Reuse the repo's existing git identity:

              $ git bug user new --non-interactive \
                  --name  "$(git config user.name)" \
                  --email "$(git config user.email)"
        '';
      };
    };
  };
}
