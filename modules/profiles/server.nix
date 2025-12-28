{
  config,
  lib,
  pkgs,
  ...
}:
{
  features = {
    terminal.zsh.enable = lib.mkDefault true;
    terminal.tools.enable = lib.mkDefault true;

    development.dev-tools.enable = lib.mkDefault true;
    development.nodejs.enable = lib.mkDefault true;
    development.git.enable = lib.mkDefault true;

    media.processing.enable = lib.mkDefault true;

    security.onepassword = {
      enable = lib.mkDefault true;
      enableGui = lib.mkDefault false;
    };
    security.sshd.enable = lib.mkDefault true;
  };
}
