{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.features.apps.vscode;
in
{
  options.features.apps.vscode = {
    enable = lib.mkEnableOption "Visual Studio Code";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      vscode.fhs
    ];
  };
}
