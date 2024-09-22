{ pkgs, firefox-gnome-theme, ...}:
{
  imports = [
    ../../config.nix
  ];

  users.users.james = {
    isNormalUser = true;
    description = "James Birtles";
    extraGroups = [ "networkmanager" "wheel" "docker" ];
    packages = with pkgs; [
      bitwarden-desktop
      chromium
    ];
  };

  home-manager.extraSpecialArgs = {
    inherit firefox-gnome-theme;
  };
  home-manager.users.james = {
    home.stateVersion = "23.11";
    xdg.enable = true;

    imports = [
      ../accounts.nix
      ../programs.nix
      ./dconf.nix
      ./programs.nix
    ];
  };
}
