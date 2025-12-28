{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.features.desktop.gnome;
in
{
  options.features.desktop.gnome = {
    enable = lib.mkEnableOption "GNOME desktop environment";
  };

  config = lib.mkIf cfg.enable {
    # System-level configuration
    services.xserver.enable = true;
    services.xserver.xkb = {
      layout = "gb";
      variant = "";
      options = "caps:escape";
    };

    services.displayManager.gdm.enable = true;
    services.displayManager.gdm.wayland = true;
    services.desktopManager.gnome.enable = true;

    console.keyMap = "uk";

    environment.systemPackages = with pkgs; [
      gnomeExtensions.appindicator
      gnome-tweaks
    ];

    services.udev.packages = [ pkgs.gnome-settings-daemon ];

    # Home-manager configuration for user james
    home-manager.users.james = {
      imports = [ ./home.nix ];
    };
  };
}
