{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.features.development.rust;
in
{
  options.features.development.rust = {
    enable = lib.mkEnableOption "Rust toolchain (rustc, cargo, rustfmt, clippy, rust-analyzer)";
  };

  config = lib.mkIf cfg.enable {
    home-manager.users.james = {
      home.packages = with pkgs; [
        rustc
        rustfmt
        clippy
        rust-analyzer
      ];

      programs.cargo = {
        enable = true;
        # libgit2 (used by cargo) struggles with SSH auth via ssh-agent for
        # private git dependencies; delegate to the git CLI which handles
        # ssh-agent, ~/.ssh/config, and credential helpers correctly.
        settings.net.git-fetch-with-cli = true;
      };
    };
  };
}
