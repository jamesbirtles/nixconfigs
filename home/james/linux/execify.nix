{ pkgs, vscode-extensions, ... }:
{
  home.packages = with pkgs; [
    slack
    notion-app-enhanced
    _1password-gui
    zoom-us
    zed-editor
    vscode.fhs
    ngrok
    nodejs_22
    corepack_22
  ];
}
