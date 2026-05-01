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
  # Note: Frigate uses Python str.format() syntax — {VAR} not ${VAR}.
  dvrRtsp = idc: ids: "rtsp://{FRIGATE_RTSP_USER}:{FRIGATE_RTSP_PASSWORD}@dvr.local:554/mode=real&idc=${toString idc}&ids=${toString ids}";

  mkCamera = { idc, width, height }: {
    ffmpeg.inputs = [
      {
        # Main stream — pulled from go2rtc restream (go2rtc owns the DVR connection)
        path = "rtsp://localhost:8554/channel_${toString idc}";
        roles = [ "record" ];
      }
      {
        # Sub-stream — pulled from go2rtc restream
        path = "rtsp://localhost:8554/channel_${toString idc}_sub";
        roles = [ "detect" ];
      }
    ];
    detect = {
      enabled = true;
      width = 352;
      height = 288;
      fps = 5;
    };
  };

  modelDir = "/var/lib/frigate/models";
  modelXml = "${modelDir}/ssdlite_mobilenet_v2.xml";
  modelBin = "${modelDir}/ssdlite_mobilenet_v2.bin";
  modelBaseUrl = "https://storage.openvinotoolkit.org/repositories/open_model_zoo/2022.3/models_bin/1/ssdlite_mobilenet_v2/FP16";
in
{
  options.features.services.frigate = {
    enable = lib.mkEnableOption "Frigate NVR";
  };

  config = lib.mkIf cfg.enable {
    # Required for Intel iGPU access (OpenVINO detector + VAAPI decode)
    hardware.graphics.enable = true;

    networking.firewall.allowedTCPPorts = [ 80 8554 8555 ];
    networking.firewall.allowedUDPPorts = [ 8555 ];

    systemd.services.frigate = {
      serviceConfig.EnvironmentFile = "/etc/frigate/credentials";
      # Download OpenVINO model on first run if not already present
      preStart = ''
        mkdir -p ${modelDir}
        if [ ! -f ${modelXml} ]; then
          echo "Downloading OpenVINO ssdlite_mobilenet_v2 model..."
          ${pkgs.curl}/bin/curl -fsSL -o ${modelXml} "${modelBaseUrl}/ssdlite_mobilenet_v2.xml"
          ${pkgs.curl}/bin/curl -fsSL -o ${modelBin} "${modelBaseUrl}/ssdlite_mobilenet_v2.bin"
        fi
      '';
    };

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

        # Intel VAAPI hardware decoding — reduces CPU load on high-res streams
        ffmpeg.hwaccel_args = "preset-vaapi";

        detectors = {
          intel_gpu = {
            type = "openvino";
            device = "GPU";
          };
        };

        model = {
          width = 300;
          height = 300;
          input_tensor = "nhwc";
          input_pixel_format = "bgr";
          model_type = "ssd";
          path = modelXml;
          labelmap_path = "${pkgs.frigate}/share/frigate/labelmap.txt";
        };

        # Object-detection triggered recording.
        # To switch to 24/7, set retain.days = N here.
        record = {
          enabled = true;
          retain.days = 0;
          events.retain = {
            default = 14;
            mode = "active_objects";
          };
        };

        go2rtc.streams = {
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
