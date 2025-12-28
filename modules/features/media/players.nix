{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.features.media.players;
in
{
  options.features.media.players = {
    enable = lib.mkEnableOption "Media player applications";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      vlc
      (kodi-wayland.withPackages (
        kodiPkgs: with kodiPkgs; [
          pvr-iptvsimple
        ]
      ))
    ];
  };
}
