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
    development.nodejs.enable = lib.mkDefault true;
    development.cloud-tools.enable = lib.mkDefault true;

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

    # Terminal
    terminal.zsh.enable = lib.mkDefault true;
    terminal.ghostty.enable = lib.mkDefault true;
    terminal.tools.enable = lib.mkDefault true;

    # Development
    development.cursor.enable = lib.mkDefault true;
    development.zed.enable = lib.mkDefault true;
    development.vscode.enable = lib.mkDefault true;

    # Productivity
    productivity.browsers.enable = lib.mkDefault true;
    productivity.misc.enable = lib.mkDefault true;

    # Communication
    communication.email.enable = lib.mkDefault true;

    # Media
    media.players.enable = lib.mkDefault true;
    media.processing.enable = lib.mkDefault true;
    media.obs-studio.enable = lib.mkDefault true;

    # Services
    services.flatpak.enable = lib.mkDefault true;
  };
}
