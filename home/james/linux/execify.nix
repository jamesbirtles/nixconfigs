{ pkgs, vscode-extensions, ... }:
{
  home.packages = with pkgs; [
    slack
    notion-app-enhanced
    _1password-gui
    zoom-us
  ];
  programs.vscode = {
    enable = true;
    enableUpdateCheck = false;
    enableExtensionUpdateCheck = false;
    extensions = with vscode-extensions; [
      ms-vsliveshare.vsliveshare
      asvetliakov.vscode-neovim
    ];
    userSettings = {
      "window.titleBarStyle" = "custom";
      "extensions.experimental.affinity" = {
        "asvetliakov.vscode-neovim" = 1;
      };
    };
  };
}
