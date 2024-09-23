{ pkgs, ... }:
{
  home.packages = with pkgs; [
    raycast
    vlc-bin
  ];
  programs.alacritty.settings.font.size = 16;
  programs.alacritty.settings.font.normal.family = "BerkeleyMonoVariable Nerd Font Mono";
}
