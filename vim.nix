{ config, pkgs, ... }:
{
  environment.variables.EDITOR = "nvim";
  programs.nixvim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    colorschemes.ayu.enable = true;
  };
}
