{ config, lib, pkgs, ... }:
let
  cfg = config.features.services.flatpak;
in
{
  options.features.services.flatpak = {
    enable = lib.mkEnableOption "Flatpak application sandboxing";
  };

  config = lib.mkIf cfg.enable {
    services.flatpak.enable = true;

    systemd.services.flatpak-repo = {
      wantedBy = [ "multi-user.target" ];
      path = [ pkgs.flatpak ];
      script = ''
        flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
      '';
    };

    programs.appimage = {
      enable = true;
      binfmt = true;
    };
  };
}
