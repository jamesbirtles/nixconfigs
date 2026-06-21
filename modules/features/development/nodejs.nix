{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.features.development.nodejs;
in
{
  options.features.development.nodejs = {
    enable = lib.mkEnableOption "Node.js development environment";
  };

  config = lib.mkIf cfg.enable {
    home-manager.users.james = {
      home.packages = with pkgs; [
        corepack_22
        typescript-language-server
      ];

      # Writable global prefix so `npm link`/`npm i -g` work (default prefix
      # points into the read-only Nix store). Installs nodejs_22 + npm and
      # manages ~/.npmrc.
      programs.npm = {
        enable = true;
        package = pkgs.nodejs_22;
      };

      home.sessionPath = [ "$HOME/.npm/bin" ];
    };
  };
}
