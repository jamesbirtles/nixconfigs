{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.features.services.frigate;

  # Credentials are injected at runtime via EnvironmentFile — not stored in
  # the nix store. Create /etc/frigate/credentials on the server:
  #
  #   FRIGATE_RTSP_USER=admin
  #   FRIGATE_RTSP_PASSWORD=yourpassword
  #   FRIGATE_MQTT_USER=frigate         # HA user created for Frigate
  #   FRIGATE_MQTT_PASSWORD=yourpassword
  #
  # chmod 600 /etc/frigate/credentials
  #
  # go2rtc uses ${VAR} env-var substitution (escaped in Nix as \${VAR})
  dvrRtsp = idc: ids: "rtsp://\${FRIGATE_RTSP_USER}:\${FRIGATE_RTSP_PASSWORD}@dvr.local:554/mode=real&idc=${toString idc}&ids=${toString ids}";

  mkCamera = { idc, width, height }: {
    ffmpeg.inputs = [
      {
        path = "rtsp://localhost:8554/channel_${toString idc}";
        roles = [ "record" ];
        hwaccel_args = "preset-vaapi";
      }
    ];
    # Detection disabled until model is sorted out
    detect.enabled = false;
  };

in
{
  options.features.services.frigate = {
    enable = lib.mkEnableOption "Frigate NVR";
  };

  config = lib.mkIf cfg.enable {
    # Required for Intel iGPU access (OpenVINO detector + VAAPI decode)
    hardware.graphics.enable = true;

    networking.firewall.allowedTCPPorts = [ 80 1984 8554 8555 ];
    networking.firewall.allowedUDPPorts = [ 8555 ];

    systemd.services.frigate = {
      serviceConfig = {
        EnvironmentFile = "/etc/frigate/credentials";
        # Needed for Intel GPU performance counters (suppresses PMU permission error)
        AmbientCapabilities = [ "CAP_PERFMON" ];
        TimeoutStopSec = 15;
      };
    };

    # go2rtc holds the DVR connections and fans out to Frigate + live view clients.
    # Credentials are loaded from the same file as Frigate so ${VAR} is substituted.
    services.go2rtc = {
      enable = true;
      settings.streams = {
        channel_1     = [ (dvrRtsp 1 1) ];
        channel_1_sub = [ (dvrRtsp 1 2) ];
        channel_2     = [ (dvrRtsp 2 1) ];
        channel_2_sub = [ (dvrRtsp 2 2) ];
        channel_3     = [ (dvrRtsp 3 1) ];
        channel_3_sub = [ (dvrRtsp 3 2) ];
        channel_4     = [ (dvrRtsp 4 1) ];
        channel_4_sub = [ (dvrRtsp 4 2) ];
        channel_5     = [ (dvrRtsp 5 1) ];
        channel_5_sub = [ (dvrRtsp 5 2) ];
        channel_6     = [ (dvrRtsp 6 1) ];
        channel_6_sub = [ (dvrRtsp 6 2) ];
      };
    };

    systemd.services.go2rtc.serviceConfig.EnvironmentFile = "/etc/frigate/credentials";

    services.frigate = {
      enable = true;
      hostname = "thinkpad-server";
      checkConfig = false;

      settings = {
        mqtt = {
          enabled = true;
          host = "homeassistant.local";
          port = 1883;
          user = "{FRIGATE_MQTT_USER}";
          password = "{FRIGATE_MQTT_PASSWORD}";
        };


        model = {
          width = 320;
          height = 320;
        };

        objects.track = [];

        record = {
          enabled = true;
          retain.days = 7;
        };

        cameras = {
          channel_1 = mkCamera { idc = 1; width = 2560; height = 1944; };
          channel_2 = mkCamera { idc = 2; width = 2560; height = 1944; };
          channel_3 = mkCamera { idc = 3; width = 928; height = 576; };
          channel_4 = mkCamera { idc = 4; width = 928; height = 576; };
          channel_5 = mkCamera { idc = 5; width = 928; height = 576; };
          channel_6 = mkCamera { idc = 6; width = 2560; height = 1944; };
        };
      };
    };
  };
}
