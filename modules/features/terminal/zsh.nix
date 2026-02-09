{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.features.terminal.zsh;

  zellijAutoCompletion = pkgs.runCommand "zellij-completion" { } ''
    mkdir -p $out
    ${pkgs.zellij}/bin/zellij setup --generate-completion zsh | sed -Ee 's/^(_(zellij) ).*/compdef \1\2/' > $out/zellij-autocomplete.plugin.zsh
  '';
in
{
  options.features.terminal.zsh = {
    enable = lib.mkEnableOption "Zsh shell with oh-my-posh and direnv";
  };

  config = lib.mkIf cfg.enable {
    # Home-manager configuration for user james
    home-manager.users.james = { config, ... }: {
      programs.zsh = {
        enable = true;
        dotDir = "${config.xdg.configHome}/zsh";
        autosuggestion.enable = true;
        syntaxHighlighting.enable = true;
        plugins = [
          {
            name = "zellij-autocomplete";
            src = zellijAutoCompletion;
          }
        ];
        shellAliases = {
          lg = "lazygit";
          nb = "nixos-rebuild-notify";
          nu = "nix flake update --commit-lock-file";
          nix-repair = "sudo nix-store --repair --verify --check-contents";
          kit = "zellij --layout sveltekit";
          mkit = "zellij --layout sveltekit-mini";
        };
      };

      programs.oh-my-posh = {
        enable = true;
        settings = {
          "$schema" = "https://raw.githubusercontent.com/JanDeDobbeleer/oh-my-posh/main/themes/schema.json";
          version = 4;
          blocks = [
            {
              alignment = "left";
              type = "prompt";
              segments = [
                {
                  foreground = "#7E46B6";
                  style = "plain";
                  template = "{{ .UserName }}{{ if .SSHSession }}@{{ .HostName }}{{ end }} ";
                  type = "session";
                }
                {
                  foreground = "#ffffff";
                  style = "plain";
                  template = "in ";
                  type = "text";
                }
                {
                  foreground = "#87FF00";
                  properties = {
                    style = "full";
                  };
                  style = "plain";
                  template = "{{ .Path }} ";
                  type = "path";
                }
                {
                  foreground = "#5FD7FF";
                  properties = {
                    branch_ahead_icon = "";
                    branch_behind_icon = "";
                    branch_gone_icon = "";
                    branch_icon = "";
                    branch_identical_icon = "";
                    cherry_pick_icon = "";
                    commit_icon = "";
                    fetch_status = true;
                    merge_icon = "";
                    rebase_icon = "";
                    revert_icon = "";
                    tag_icon = "";
                  };
                  style = "plain";
                  template = "<#ffffff>on</> {{ .HEAD }}{{ if .Staging.Changed }}<#87FF00> ● {{ .Staging.String }}</>{{ end }}{{ if .Working.Changed }}<#D75F00> ● {{ .Working.String }}</>{{ end }} ";
                  type = "git";
                }
                {
                  foreground = "#D75F00";
                  style = "plain";
                  template = "λ ";
                  type = "text";
                }
              ];
            }
          ];
        };
      };

      programs.direnv = {
        enable = true;
        enableZshIntegration = true;
        nix-direnv.enable = true;
      };
    };
  };
}
