{ config, lib, pkgs, ... }:
{
  # Minimal server - just docker, no GUI
  features = {
    development.docker.enable = lib.mkDefault true;
  };
}
