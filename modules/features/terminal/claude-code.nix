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
        settings = {
          permissions = {
            allow = [
              # Git (read-only)
              "Bash(git status:*)"
              "Bash(git diff:*)"
              "Bash(git log:*)"
              "Bash(git branch:*)"
              "Bash(git show:*)"
              "Bash(git blame:*)"
              "Bash(git rev-parse:*)"
              "Bash(git add:*)"

              # Node (build/test/lint)
              "Bash(npm run:*)"
              "Bash(npm test:*)"
              "Bash(npm install:*)"
              "Bash(npm ci:*)"
              "Bash(npm ls:*)"
              "Bash(npm outdated:*)"
              "Bash(tsc:*)"
              "Bash(eslint:*)"
              "Bash(prettier:*)"
              "Bash(npx tsc:*)"
              "Bash(npx eslint:*)"
              "Bash(npx prettier:*)"
              "Bash(npx vitest:*)"
            ];
          };
        };
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
