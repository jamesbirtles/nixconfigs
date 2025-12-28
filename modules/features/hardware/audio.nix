{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.features.hardware.audio;
in
{
  options.features.hardware.audio = {
    enable = lib.mkEnableOption "PipeWire audio system";
  };

  config = lib.mkIf cfg.enable {
    services.pulseaudio.enable = false;
    security.rtkit.enable = true;

    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };
  };
}
