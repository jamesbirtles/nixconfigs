{ pkgs, vscode-extensions, ... }:
{
  home.packages = with pkgs; [
    slack
    notion-app-enhanced
    _1password-gui
    zoom-us
    zed-editor
    ngrok
    nodejs_20
    corepack_20
    jetbrains-toolbox
  ];
}
