{
  config,
  lib,
  omp,
  ...
}:
let
  cfg = config.features.terminal.omp;
in
{
  options.features.terminal.omp = {
    enable = lib.mkEnableOption "omp (Oh My Pi) coding agent";
  };

  config = lib.mkIf cfg.enable {
    home-manager.users.james = {
      imports = [ omp.homeManagerModules.default ];
      programs.oh-my-pi.enable = true;
    };
  };
}
