{ config, lib, pkgs, ... }:
let
  cfg = config.features.services.rclone-mount;
in
{
  options.features.services.rclone-mount = {
    enable = lib.mkEnableOption "ProtonDrive rclone mount";
  };

  config = lib.mkIf cfg.enable {
    fileSystems."/home/james/ProtonDrive" = {
      device = "protondrive:";
      fsType = "rclone";
      options = [
        "nodev"
        "nofail"
        "allow_other"
        "args2env"
        "config=/home/james/.config/rclone/rclone.conf"
      ];
    };
  };
}
