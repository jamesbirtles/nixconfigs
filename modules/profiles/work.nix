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
    communication.slack.enable = lib.mkDefault true;
    communication.thunderbird.enable = lib.mkDefault true;
  };
}
