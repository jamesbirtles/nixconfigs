{ config, lib, pkgs, zen-browser, ... }:
let
  cfg = config.features.media.apps;
in
{
  options.features.media.apps = {
    enable = lib.mkEnableOption "Media and productivity applications";
  };

  config = lib.mkIf cfg.enable {
    programs.chromium.enable = true;

    fonts.fontDir.enable = true;

    environment.systemPackages = with pkgs; [
      # Media players
      vlc
      (kodi-wayland.withPackages (kodiPkgs: with kodiPkgs; [
        pvr-iptvsimple
      ]))

      # Communication
      thunderbird
      slack

      # Browsers
      zen-browser

      # Productivity
      obsidian

      # Remote desktop
      parsec-bin

      # 3D printing
      prusa-slicer
      orca-slicer

      # Development
      vscode.fhs

      # VPN
      protonvpn-gui
      openconnect

      # Utilities
      wl-clipboard
      dconf2nix
      playerctl
    ];

    # systemd tmpfiles rule for xdg-desktop-portal (for screensharing in zoom, etc.)
    systemd.tmpfiles.rules = [
      "L+ /usr/libexec/xdg-desktop-portal - - - - ${pkgs.xdg-desktop-portal}/libexec/xdg-desktop-portal"
    ];

    security.polkit.enable = true;
  };
}
