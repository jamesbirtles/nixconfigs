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
    services.desktopManager.gnome.enable = true;

    # Backport of nixpkgs PR #523948 — without it, GDM 50's greeter PAM session
    # has no PATH and can't exec gnome-session, so the login screen never appears.
    # Remove once nixos-unstable channel advances past commit 60fe2249 (2026-06-02).
    security.pam.services.gdm-launch-environment.rules.session.env-greeter = {
      order = config.security.pam.services.gdm-launch-environment.rules.session.env.order + 50;
      control = "required";
      modulePath = "${config.security.pam.package}/lib/security/pam_env.so";
      settings.conffile = pkgs.writeText "gdm-launch-environment-env-conf" ''
        PATH          DEFAULT="''${PATH}:${pkgs.gnome-session}/bin"
        XDG_DATA_DIRS DEFAULT="''${XDG_DATA_DIRS}:${config.services.displayManager.generic.environment.XDG_DATA_DIRS}"
      '';
      settings.readenv = 0;
    };

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
