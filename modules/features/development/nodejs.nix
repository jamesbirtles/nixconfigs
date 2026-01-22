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
        nodejs_22
        corepack_22
        typescript-language-server
      ];
    };
  };
}
