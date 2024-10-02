{ pkgs, ... }:
{
  home.packages = with pkgs; [
    slack
    notion-app-enhanced
    _1password-gui
    zoom-us
  ];
}
