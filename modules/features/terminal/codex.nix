{
  config,
  lib,
  pkgs,
  google-chrome-dev,
  ...
}:
let
  cfg = config.features.terminal.codex;

  # Codex rewrites config.toml at runtime (e.g. to persist per-directory
  # trust), so it can't live as a read-only home-manager store symlink.
  # We generate it here and seed it as a writable file via an activation
  # script below.
  codexConfig = (pkgs.formats.toml { }).generate "codex-config.toml" {
    mcp_servers.chrome-devtools = {
      command = "${pkgs.nodejs}/bin/npx";
      args = [
        "-y"
        "chrome-devtools-mcp@latest"
        "--executablePath"
        "${google-chrome-dev}/bin/google-chrome-unstable"
        "--acceptInsecureCerts"
      ];
    };
  };
in
{
  options.features.terminal.codex = {
    enable = lib.mkEnableOption "OpenAI Codex CLI";
  };

  config = lib.mkIf cfg.enable {
    home-manager.users.james = { lib, ... }: {
      programs.codex = {
        enable = true;
        context = ./agents-context.md;
      };

      # Refresh config.toml only when the generated content changes, so trust
      # entries Codex writes at runtime survive ordinary rebuilds.
      home.activation.codexConfig = lib.hm.dag.entryAfter [ "linkGeneration" ] ''
        target="$HOME/.codex/config.toml"
        marker="$HOME/.codex/.config.toml.hm-source"
        if [ ! -e "$target" ] || [ "$(cat "$marker" 2>/dev/null)" != "${codexConfig}" ]; then
          run install -Dm600 ${codexConfig} "$target"
          run echo "${codexConfig}" > "$marker"
        fi
      '';
    };
  };
}
