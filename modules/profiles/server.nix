{
  config,
  lib,
  pkgs,
  ...
}:
{
  features = {
    shell.zsh.enable = lib.mkDefault true;
    apps.terminal.enable = lib.mkDefault true;
  };
}
