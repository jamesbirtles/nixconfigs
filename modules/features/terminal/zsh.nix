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
    home-manager.users.james = {
      programs.zsh = {
        enable = true;
        autosuggestion.enable = true;
        syntaxHighlighting.enable = true;
        plugins = [
          {
            name = "zellij-autocomplete";
            src = zellijAutoCompletion;
          }
        ];
        shellAliases = {
          nb = "sudo nixos-rebuild switch --flake .#";
          nu = "nix flake update --commit-lock-file";
          nix-repair = "sudo nix-store --repair --verify --check-contents";
          kit = "zellij --layout sveltekit";
          mkit = "zellij --layout sveltekit-mini";
        };
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
    };
  };
}
