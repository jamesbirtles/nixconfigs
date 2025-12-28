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

    # Hardware
    ./hardware/audio.nix
    ./hardware/printing.nix
    ./hardware/fingerprint.nix
    ./hardware/fwupd.nix

    # Security
    ./security/onepassword.nix
    ./security/rbw.nix
    ./security/ssh.nix
    ./security/vpn.nix

    # Shell
    ./shell/zsh.nix

    # Media
    ./media/players.nix
    ./media/processing.nix

    # Services
    ./services/flatpak.nix
    ./services/rclone-mount.nix

    # Apps
    ./apps/cursor.nix
    ./apps/zed.nix
    ./apps/browsers.nix
    ./apps/ghostty.nix
    ./apps/obs-studio.nix
    ./apps/terminal.nix
    ./apps/email.nix
    ./apps/communication.nix
    ./apps/vscode.nix
    ./apps/3d-printing.nix
    ./apps/productivity.nix
  ];
}
