{
  config,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    # Desktop
    ./desktop/gnome
    ./desktop/niri

    # Gaming
    ./gaming/steam.nix
    ./gaming/performance.nix

    # Development
    ./development/docker.nix
    ./development/git.nix
    ./development/dev-tools.nix
    ./development/nodejs.nix
    ./development/cloud-tools.nix
    ./development/cursor.nix
    ./development/vscode.nix
    ./development/zed.nix

    # Terminal
    ./terminal/ghostty.nix
    ./terminal/tools.nix
    ./terminal/zsh.nix

    # Productivity
    ./productivity/browsers.nix
    ./productivity/misc.nix

    # Creative
    ./creative/3d-printing.nix

    # Communication
    ./communication/email.nix
    ./communication/discord.nix
    ./communication/slack.nix
    ./communication/thunderbird.nix

    # Hardware
    ./hardware/audio.nix
    ./hardware/printing.nix
    ./hardware/fingerprint.nix
    ./hardware/fwupd.nix

    # Security
    ./security/onepassword.nix
    ./security/rbw.nix
    ./security/ssh.nix
    ./security/sshd.nix
    ./security/vpn.nix

    # Media
    ./media/players.nix
    ./media/processing.nix
    ./media/obs-studio.nix

    # Services
    ./services/flatpak.nix
    ./services/rclone-mount.nix
  ];
}
