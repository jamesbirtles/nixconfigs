{ pkgs, vscode-extensions, ... }:
{
  home.packages = with pkgs; [
    slack
    notion-app-enhanced
    _1password-gui
    zoom-us
    zed-editor
  ];
  programs.vscode = {
    enable = true;
    enableUpdateCheck = false;
    enableExtensionUpdateCheck = false;
    extensions = with vscode-extensions; [
      ms-vsliveshare.vsliveshare
      asvetliakov.vscode-neovim
      svelte.svelte-vscode
    ];
    userSettings = {
      "window.titleBarStyle" = "custom";
      "extensions.experimental.affinity" = {
        "asvetliakov.vscode-neovim" = 1;
      };
      "svelte.enable-ts-plugin" = true;
      "typescript.tsserver.maxTsServerMemory" = 4096;
    };
  };
}
