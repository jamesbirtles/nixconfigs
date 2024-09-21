{ nixpkgs, lib, pkgs, ... }:
{
  home-manager.users.james = {
    home.packages = with pkgs; [
      raycast
      vlc-bin
    ];
    programs.alacritty.settings.font.size = 15;
  };
}
