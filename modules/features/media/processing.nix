{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.features.media.processing;
in
{
  options.features.media.processing = {
    enable = lib.mkEnableOption "Media processing tools and libraries";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      ffmpeg
      tsduck
      gst_all_1.gstreamer
      gst_all_1.gst-plugins-base
      gst_all_1.gst-plugins-good
      gst_all_1.gst-plugins-bad
      gst_all_1.gst-plugins-ugly
      gst_all_1.gst-plugins-rs
      gst_all_1.gst-libav
      gst_all_1.gst-vaapi
    ];
  };
}
