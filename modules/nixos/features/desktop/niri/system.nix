{ config, lib, pkgs, ... }:
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

    environment.systemPackages = with pkgs; [
      xwayland-satellite
      brightnessctl
    ];
  };
}
