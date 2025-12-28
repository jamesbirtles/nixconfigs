{ config, lib, pkgs, ... }:
{
  users.defaultUserShell = pkgs.zsh;

  programs.zsh.enable = true;

  programs.gnupg.agent.enable = true;

  # Define user james
  users.users.james = {
    isNormalUser = true;
    description = "James Birtles";
    extraGroups = [
      "networkmanager"
      "wheel"
      "docker"
    ];
  };

  # Home-manager integration
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;

  # Common home-manager config for user james
  home-manager.users.james = {
    home.stateVersion = "23.11";
    xdg.enable = true;
  };
}
