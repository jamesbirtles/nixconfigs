{
  pkgs,
  firefox-gnome-theme,
  vscode-extensions,
  walker,
  ashell,
  ...
}:
{
  imports = [
    ../../config.nix
  ];

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
    ];
  };

  home-manager.extraSpecialArgs = {
    inherit firefox-gnome-theme vscode-extensions ashell walker;
  };
  home-manager.users.james = {
    imports = [
      ../accounts.nix
      ../programs.nix
      ./dconf.nix
      ./cursor.nix
      ./programs.nix
      walker.homeManagerModules.default
      # Note: niri.nix now handled by features/desktop/niri module
      # Note: home.stateVersion and xdg.enable now in core/users.nix
    ];
  };
}
