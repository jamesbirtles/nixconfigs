{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.features.communication.thunderbird;
in
{
  options.features.communication.thunderbird = {
    enable = lib.mkEnableOption "Thunderbird";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      thunderbird
    ];
  };
}
