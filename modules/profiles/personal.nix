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
    gaming.steam.enable = lib.mkDefault true;
    gaming.performance.enable = lib.mkDefault true;
    services.rclone-mount.enable = lib.mkDefault true;
    creative."3d-printing".enable = lib.mkDefault true;
    communication.discord.enable = lib.mkDefault true;
  };
}
