{
  config,
  lib,
  pkgs,
  voxtype,
  ...
}:
let
  cfg = config.features.productivity.speech;
  voxtypePkg = voxtype.packages.${pkgs.stdenv.hostPlatform.system}.vulkan;
  voxtype-status-themed = pkgs.writeShellApplication {
    name = "voxtype-status-themed";
    runtimeInputs = [ voxtypePkg pkgs.jq ];
    text = ''
      voxtype status --follow --format json | jq --unbuffered -c '
        . + (
          if .class == "recording" then
            { text: "Recording", icon: "microphone-2", iconColor: "error", textColor: "error" }
          elif .class == "transcribing" then
            { text: "Transcribing", icon: "loader", iconColor: "tertiary", textColor: "tertiary" }
          else
            { text: "", icon: "microphone", iconColor: "none" }
          end
        )
      '
    '';
  };
in
{
  options.features.productivity.speech = {
    enable = lib.mkEnableOption "Speech-to-text voice input (voxtype)";
  };

  config = lib.mkIf cfg.enable {
    home-manager.users.james = {
      imports = [ voxtype.homeManagerModules.default ];

      home.packages = [ voxtype-status-themed ];

      programs.voxtype = {
        enable = true;
        package = voxtypePkg;
        engine = "whisper";
        model.name = "large-v3-turbo";
        service.enable = true;
        settings = {
          hotkey.enabled = false;
          whisper = {
            language = "en";
            translate = false;
          };
          audio.feedback = {
            enabled = true;
            theme = "subtle";
            volume = 0.6;
          };
          output = {
            mode = "type";
            fallback_to_clipboard = true;
            type_delay_ms = 8;
            pre_type_delay_ms = 20;
          };
          output.notification = {
            on_recording_start = false;
            on_recording_stop = false;
            on_transcription = false;
          };
        };
      };
    };
  };
}
