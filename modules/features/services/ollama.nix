{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.features.services.ollama;
in
{
  options.features.services.ollama = {
    enable = lib.mkEnableOption "Ollama local LLM server";
  };

  config = lib.mkIf cfg.enable {
    services.ollama = {
      enable = true;
      package = pkgs.ollama-vulkan;
    };
  };
}
