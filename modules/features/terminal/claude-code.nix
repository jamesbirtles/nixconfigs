{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.features.terminal.claude-code;

  statusLineScript = pkgs.writeShellScript "claude-statusline" ''
    input=$(cat)
    cwd=$(echo "$input" | ${pkgs.jq}/bin/jq -r '.workspace.current_dir // .cwd')
    model=$(echo "$input" | ${pkgs.jq}/bin/jq -r '.model.display_name // ""')
    used=$(echo "$input" | ${pkgs.jq}/bin/jq -r '.context_window.used_percentage // empty')

    # Username (purple)
    user_part=$(printf '\033[38;2;126;70;182m%s\033[0m' "$(whoami)")

    # "in" (white)
    in_part=$(printf '\033[37min\033[0m')

    # Path (green #87FF00)
    path_part=$(printf '\033[38;2;135;255;0m%s\033[0m' "$cwd")

    # Git branch (cyan #5FD7FF) — skip locks to avoid blocking
    branch=""
    if git -C "$cwd" rev-parse --git-dir >/dev/null 2>&1; then
      branch=$(git -C "$cwd" symbolic-ref --short HEAD 2>/dev/null || git -C "$cwd" rev-parse --short HEAD 2>/dev/null)
    fi
    if [ -n "$branch" ]; then
      on_part=$(printf '\033[37mon\033[0m')
      branch_part=$(printf '\033[38;2;95;215;255m%s\033[0m' "$branch")
    fi

    # Model (dimmed)
    if [ -n "$model" ]; then
      model_part=$(printf '\033[2m[%s]\033[0m' "$model")
    fi

    # Context usage
    if [ -n "$used" ]; then
      ctx_part=$(printf '\033[2m%s%%\033[0m' "$used")
    fi

    # Assemble
    line="$user_part $in_part $path_part"
    if [ -n "$branch" ]; then
      line="$line $on_part $branch_part"
    fi
    if [ -n "$model_part" ]; then
      line="$line $model_part"
    fi
    if [ -n "$ctx_part" ]; then
      line="$line $ctx_part"
    fi

    printf '%s\n' "$line"
  '';
in
{
  options.features.terminal.claude-code = {
    enable = lib.mkEnableOption "Claude Code CLI";
  };

  config = lib.mkIf cfg.enable {
    home-manager.users.james = {
      home.file.".claude/statusline-command.sh".source = statusLineScript;

      programs.claude-code = {
        enable = true;
        settings = {
          statusLine = {
            type = "command";
            command = "${statusLineScript}";
          };
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
