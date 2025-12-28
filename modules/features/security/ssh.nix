{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.features.security.ssh;
in
{
  options.features.security.ssh = {
    enable = lib.mkEnableOption "SSH client with 1Password integration";
  };

  config = lib.mkIf cfg.enable {
    # Home-manager configuration for user james
    home-manager.users.james = {
      programs.ssh = {
        enable = true;
        enableDefaultConfig = false;
        matchBlocks."*" = {
          identityAgent = "~/.1password/agent.sock";
        };
      };
    };
  };
}
