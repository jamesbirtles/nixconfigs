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
    media.processing.enable = lib.mkDefault true;
  };
}
