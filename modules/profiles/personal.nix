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
    apps."3d-printing".enable = lib.mkDefault true;
    apps.discord.enable = lib.mkDefault true;
  };
}
