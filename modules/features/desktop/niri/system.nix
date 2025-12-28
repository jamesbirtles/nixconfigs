{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.features.desktop.niri;
in
{
  options.features.desktop.niri = {
    enable = lib.mkEnableOption "Niri scrollable-tiling Wayland compositor";
  };

  config = lib.mkIf cfg.enable {
    programs.niri = {
      enable = true;
      package = pkgs.niri;
    };

    environment.sessionVariables = {
      NIXOS_OZONE_WL = "1";
      ZED_WINDOW_DECORATIONS = "server";
    };

    security.pam.services.swaylock = { };
    security.polkit.enable = true;

    # systemd tmpfiles rule for xdg-desktop-portal (for screensharing)
    systemd.tmpfiles.rules = [
      "L+ /usr/libexec/xdg-desktop-portal - - - - ${pkgs.xdg-desktop-portal}/libexec/xdg-desktop-portal"
    ];

    environment.systemPackages = with pkgs; [
      xwayland-satellite
      brightnessctl
      wl-clipboard
      playerctl
    ];
  };
}
