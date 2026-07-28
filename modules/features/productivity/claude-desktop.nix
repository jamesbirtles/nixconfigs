{
  config,
  lib,
  claude-desktop,
  ...
}:
let
  cfg = config.features.productivity.claude-desktop;
in
{
  options.features.productivity.claude-desktop = {
    enable = lib.mkEnableOption "Claude Desktop (unofficial Linux repackaging)";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [
      claude-desktop
    ];
  };
}
