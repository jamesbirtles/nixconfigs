{
  config,
  lib,
  claude-desktop-pkg,
  ...
}:
let
  cfg = config.features.communication.claude-desktop;
in
{
  options.features.communication.claude-desktop = {
    enable = lib.mkEnableOption "Claude Desktop";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [
      claude-desktop-pkg
    ];
  };
}
