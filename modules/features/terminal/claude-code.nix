{
  config,
  lib,
  ...
}:
let
  cfg = config.features.terminal.claude-code;
in
{
  options.features.terminal.claude-code = {
    enable = lib.mkEnableOption "Claude Code CLI";
  };

  config = lib.mkIf cfg.enable {
    home-manager.users.james = {
      programs.claude-code = {
        enable = true;
        memory.text = ''
          When devenv.nix doesn't exist and a command/tool is missing, create ad-hoc environment:

              $ devenv -O languages.rust.enable:bool true -O packages:pkgs "mypackage mypackage2" shell -- cli args

          When the setup is becomes complex create `devenv.nix` and run commands within:

              $ devenv shell -- cli args

          See https://devenv.sh/ad-hoc-developer-environments/
        '';
      };
    };
  };
}
