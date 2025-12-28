{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.features.productivity.misc;
in
{
  options.features.productivity.misc = {
    enable = lib.mkEnableOption "Productivity and remote desktop applications";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      obsidian
      parsec-bin
    ];
  };
}
