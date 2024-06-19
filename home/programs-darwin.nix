{ nixpkgs, lib, pkgs, ... }:
{
  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
    "raycast"
  ];
  home-manager.users.james = {
    home.packages = [ pkgs.raycast ];
    programs.alacritty.settings.font.size = 15;
  };
}
