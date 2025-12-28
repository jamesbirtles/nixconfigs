{ pkgs, ... }:
{
  fonts.packages = with pkgs; [
    nerd-fonts.fira-code
    fira-code
    fira-code-symbols
  ];
}
