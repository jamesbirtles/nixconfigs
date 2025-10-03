{ pkgs, firefox-gnome-theme, vscode-extensions, ...}:
{
  imports = [
    ../../config.nix
  ];

  users.users.james = {
    isNormalUser = true;
    description = "James Birtles";
    extraGroups = [ "networkmanager" "wheel" "docker" ];
    packages = with pkgs; [
      chromium
    ];
  };

  home-manager.extraSpecialArgs = {
    inherit firefox-gnome-theme vscode-extensions;
  };
  home-manager.users.james = {
    home.stateVersion = "23.11";
    xdg.enable = true;

    imports = [
      ../accounts.nix
      ../programs.nix
      ./dconf.nix
      ./cursor.nix
      ./programs.nix
    ];
  };
}
