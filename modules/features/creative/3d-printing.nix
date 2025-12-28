{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.features.creative."3d-printing";
in
{
  options.features.creative."3d-printing" = {
    enable = lib.mkEnableOption "3D printing slicer applications";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      prusa-slicer
      orca-slicer
    ];
  };
}
