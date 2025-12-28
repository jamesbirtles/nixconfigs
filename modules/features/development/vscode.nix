{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.features.development.vscode;
in
{
  options.features.development.vscode = {
    enable = lib.mkEnableOption "Visual Studio Code";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      vscode.fhs
    ];
  };
}
