{
  config,
  lib,
  pkgs,
  voxtype,
  ...
}:
let
  cfg = config.features.productivity.speech;
  voxtypePkg = voxtype.packages.${pkgs.stdenv.hostPlatform.system}.onnx;
  parakeetModel =
    let
      base = "https://huggingface.co/istupakov/parakeet-tdt-0.6b-v3-onnx/resolve/main";
      file = name: hash: pkgs.fetchurl { url = "${base}/${name}"; inherit hash; };
    in
    pkgs.linkFarm "parakeet-tdt-0.6b-v3" [
      { name = "encoder-model.onnx";        path = file "encoder-model.onnx"        "sha256-mKdLIbTMABfB5wMDGaSpb0qVBuUPBwjzpRbQKnfJa7E="; }
      { name = "encoder-model.onnx.data";   path = file "encoder-model.onnx.data"   "sha256-miLTcsUUVcNPE0BdolILrvtxJb0WmBOXVhQj7TLSTzY="; }
      { name = "decoder_joint-model.onnx";  path = file "decoder_joint-model.onnx"  "sha256-6Xjd9miFJxgsEP3i60uDBoQhZImF7yP3qGvnMr6HBsE="; }
      { name = "vocab.txt";                 path = file "vocab.txt"                 "sha256-1YVEZ56kvGrFY9H1Ret9R0vWz6Rn8KbiwdwcfTfjw10="; }
      { name = "config.json";               path = file "config.json"               "sha256-ZmkDx2uXmMrywhCv1PbNYLCKjb+YAOyNejvA0hSKxGY="; }
    ];
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
        engine = "parakeet";
        model.path = parakeetModel;
        service.enable = true;
        settings = {
          hotkey.enabled = false;
          audio.feedback = {
            enabled = true;
            theme = "subtle";
            volume = 0.6;
          };
          output = {
            mode = "type";
            fallback_to_clipboard = true;
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
