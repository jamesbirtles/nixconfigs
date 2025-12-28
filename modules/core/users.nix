{ config, lib, pkgs, firefox-gnome-theme, vscode-extensions, walker, ashell, ... }:
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
    packages = with pkgs; [
      chromium
      gnome-obfuscate
    ];
  };

  # Home-manager integration
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.backupFileExtension = "hm-backup";

  home-manager.extraSpecialArgs = {
    inherit firefox-gnome-theme vscode-extensions ashell walker;
  };

  # Common home-manager config for user james
  home-manager.users.james = {
    imports = [
      walker.homeManagerModules.default
    ];

    home.stateVersion = "23.11";
    xdg.enable = true;
  };
}
