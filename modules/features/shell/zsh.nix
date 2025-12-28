{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.features.shell.zsh;

  zellijAutoCompletion = pkgs.runCommand "zellij-completion" { } ''
    mkdir -p $out
    ${pkgs.zellij}/bin/zellij setup --generate-completion zsh | sed -Ee 's/^(_(zellij) ).*/compdef \1\2/' > $out/zellij-autocomplete.plugin.zsh
  '';
in
{
  options.features.shell.zsh = {
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
