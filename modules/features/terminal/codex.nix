{
  config,
  lib,
  pkgs,
  google-chrome-dev,
  ...
}:
let
  cfg = config.features.terminal.codex;
in
{
  options.features.terminal.codex = {
    enable = lib.mkEnableOption "OpenAI Codex CLI";
  };

  config = lib.mkIf cfg.enable {
    home-manager.users.james = {
      programs.codex = {
        enable = true;
        settings.mcp_servers.chrome-devtools = {
          command = "${pkgs.nodejs}/bin/npx";
          args = [
            "-y"
            "chrome-devtools-mcp@latest"
            "--executablePath"
            "${google-chrome-dev}/bin/google-chrome-unstable"
            "--acceptInsecureCerts"
          ];
        };
        context = ./agents-context.md;
      };
    };
  };
}
