{
  config,
  lib,
  pkgs,
  ...
}:
{
  # Base configuration shared by desktop/laptop machines (work and personal)
  features = {
    # Desktop
    desktop.gnome.enable = lib.mkDefault true;
    desktop.niri.enable = lib.mkDefault true;

    # Development
    development.docker.enable = lib.mkDefault true;
    development.git.enable = lib.mkDefault true;
    development.dev-tools.enable = lib.mkDefault true;

    # Hardware
    hardware.audio.enable = lib.mkDefault true;
    hardware.printing.enable = lib.mkDefault true;
    hardware.fingerprint.enable = lib.mkDefault true;
    hardware.fwupd.enable = lib.mkDefault true;

    # Security
    security.onepassword.enable = lib.mkDefault true;
    security.rbw.enable = lib.mkDefault true;
    security.ssh.enable = lib.mkDefault true;
    security.vpn.enable = lib.mkDefault true;

    # Shell
    shell.zsh.enable = lib.mkDefault true;

    # Media
    media.players.enable = lib.mkDefault true;
    media.processing.enable = lib.mkDefault true;

    # Services
    services.flatpak.enable = lib.mkDefault true;

    # Apps
    apps.cursor.enable = lib.mkDefault true;
    apps.zed.enable = lib.mkDefault true;
    apps.browsers.enable = lib.mkDefault true;
    apps.ghostty.enable = lib.mkDefault true;
    apps.obs-studio.enable = lib.mkDefault true;
    apps.terminal.enable = lib.mkDefault true;
    apps.email.enable = lib.mkDefault true;
    apps.vscode.enable = lib.mkDefault true;
    apps.productivity.enable = lib.mkDefault true;
  };
}
