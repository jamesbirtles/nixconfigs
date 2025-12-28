{ config, lib, pkgs, ... }:
let
  cfg = config.features.development.docker;
in
{
  options.features.development.docker = {
    enable = lib.mkEnableOption "Docker containerization";
  };

  config = lib.mkIf cfg.enable {
    virtualisation.docker.enable = true;
  };
}
