{
  config,
  lib,
  pkgs,
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
    # omp discovers context from ~/.claude/CLAUDE.md and ~/.codex/AGENTS.md
    # (both already written by the claude-code / codex modules), so it inherits
    # agents-context.md without any wiring of its own.
    home-manager.users.james = {
      home.packages = [ (pkgs.callPackage ./package.nix { }) ];
    };
  };
}
