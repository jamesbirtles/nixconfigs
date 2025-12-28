{
  config,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    ./desktop.nix
  ];

  features = {
    apps.slack.enable = lib.mkDefault true;
    apps.thunderbird.enable = lib.mkDefault true;
  };
}
