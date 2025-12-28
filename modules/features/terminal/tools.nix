{
  config,
  lib,
  pkgs,
  outPath ? null,
  ...
}:
let
  cfg = config.features.terminal.tools;
in
{
  options.features.terminal.tools = {
    enable = lib.mkEnableOption "Terminal Apps and Tools";
  };

  config = lib.mkIf cfg.enable {
    # System-level packages
    environment.systemPackages = with pkgs; [
      jq
      rclone
      claude-code

      # Helper scripts
      (pkgs.writeShellScriptBin "check-updates" ''
        # Default values
        FLAKE_DIR="${if outPath != null then outPath else "$HOME/nixconfigs"}"
        IGNORE_INPUTS=""

        # Parse arguments
        while [[ $# -gt 0 ]]; do
          case $1 in
            --ignore)
              IGNORE_INPUTS="$2"
              shift 2
              ;;
            --flake-dir)
              FLAKE_DIR="$2"
              shift 2
              ;;
            *)
              FLAKE_DIR="$1"
              shift
              ;;
          esac
        done

        if [ ! -f "$FLAKE_DIR/flake.nix" ]; then
          echo "Error: Cannot find flake.nix at $FLAKE_DIR"
          exit 1
        fi

        # Get all direct inputs
        ${pkgs.nix}/bin/nix flake metadata "$FLAKE_DIR" --json | ${pkgs.jq}/bin/jq -r '
          .locks.nodes.root.inputs |
          to_entries[] |
          .key as $name |
          .value as $node |
          "\($name) \($node)"
        ' | while read -r name node; do
          # Check if this input should be ignored
          if echo " $IGNORE_INPUTS " | grep -q " $name "; then
            continue
          fi

          # Get the locked node info
          locked=$(${pkgs.nix}/bin/nix flake metadata "$FLAKE_DIR" --json | ${pkgs.jq}/bin/jq -r ".locks.nodes.\"$node\"")

          # Build the original reference
          original=$(echo "$locked" | ${pkgs.jq}/bin/jq -r '
            if .original.type == "github" then
              "github:\(.original.owner)/\(.original.repo)" + (if .original.ref then "/\(.original.ref)" else "" end)
            elif .original.type == "indirect" then
              .original.id
            else
              .original.url // empty
            end
          ')

          if [ -z "$original" ] || [ "$original" = "null" ]; then
            continue
          fi

          # Get fingerprints
          current=$(echo "$locked" | ${pkgs.jq}/bin/jq -r '.locked.narHash // empty')
          latest=$(${pkgs.nix}/bin/nix flake metadata "$original" --refresh --json 2>/dev/null | ${pkgs.jq}/bin/jq -r '.locked.narHash // empty')

          if [ -n "$current" ] && [ -n "$latest" ] && [ "$current" != "$latest" ]; then
            echo "$name $current -> $latest"
          fi
        done
      '')

      (pkgs.writeShellScriptBin "update-system" ''
        set -e

        echo "Updating system from: $HOME/nixconfigs"
        cd "$HOME/nixconfigs"

        # Update flake
        echo "Running nix flake update..."
        nix flake update --commit-lock-file

        # Build the system
        echo "Building system..."
        sudo nixos-rebuild switch --flake .#

        # Push if build succeeded
        echo "Build successful, pushing..."
        ${pkgs.git}/bin/git push

        echo "Done!"
        echo "Press enter to exit"
        read
      '')
    ];

    # Home-manager configuration for user james
    home-manager.users.james = {
      programs.zoxide.enable = true;
      programs.eza = {
        enable = true;
        icons = "auto";
        git = true;
      };
      programs.btop.enable = true;
      programs.ripgrep.enable = true;
      programs.fd.enable = true;
      programs.bat.enable = true;
      programs.nnn.enable = true;

      programs.zellij = {
        enable = true;
        enableZshIntegration = false;
      };

      xdg.configFile."zellij/config.kdl".text = ''
        keybinds {
          shared_except "locked" {
            unbind "Ctrl g"
            unbind "Ctrl p"
            unbind "Ctrl t"
            unbind "Ctrl n"
            unbind "Ctrl h"
            unbind "Ctrl s"
            unbind "Ctrl o"
            unbind "Ctrl q"
            bind "Alt g" { SwitchToMode "locked"; }
            bind "Alt q" { Quit; }
            bind "Alt 1" { GoToTab 1; }
            bind "Alt 2" { GoToTab 2; }
            bind "Alt 3" { GoToTab 3; }
            bind "Alt 4" { GoToTab 4; }
            bind "Alt 5" { GoToTab 5; }
            bind "Alt 6" { GoToTab 6; }
            bind "Alt 7" { GoToTab 7; }
            bind "Alt 8" { GoToTab 8; }
            bind "Alt 9" { GoToTab 9; }
            bind "Alt 0" { GoToTab 10; }
          }
          locked {
            bind "Alt g" { SwitchToMode "Normal"; }
          }

          shared_except "pane" "locked" {
            bind "Alt p" { SwitchToMode "pane"; }
          }
          pane {
            bind "Alt p" { SwitchToMode "Normal"; }
            bind "h" { NewPane "left"; }
            bind "j" { NewPane "down"; }
            bind "k" { NewPane "up"; }
            bind "l" { NewPane "right"; }
          }

          shared_except "tab" "locked" {
            bind "Alt t" { SwitchToMode "tab"; }
          }
          tab {
            bind "Alt t" { SwitchToMode "Normal"; }
          }

          shared_except "resize" "locked" {
            bind "Alt n" { SwitchToMode "resize"; }
          }
          resize {
            bind "Alt n" { SwitchToMode "Normal"; }
          }

          shared_except "move" "locked" {
            bind "Alt m" { SwitchToMode "move"; }
          }
          move {
            bind "Alt m" { SwitchToMode "Normal"; }
          }

          shared_except "search" "locked" {
            bind "Alt s" { SwitchToMode "search"; }
          }
          search {
            bind "Alt s" { SwitchToMode "Normal"; }
          }

          shared_except "session" "locked" {
            bind "Alt o" { SwitchToMode "session"; }
          }
          session {
            bind "Alt o" { SwitchToMode "Normal"; }
          }
        }
      '';

      xdg.configFile."zellij/layouts/sveltekit.kdl".text = ''
        layout {
          default_tab_template {
            pane size=1 borderless=true {
              plugin location="zellij:tab-bar"
            }
            children
            pane size=2 borderless=true {
              plugin location="zellij:status-bar"
            }
          }
          tab name="Scratch" {
            pane split_direction="vertical" {
              pane
              pane
            }
            pane split_direction="vertical" {
              pane
              pane
            }
          }
          tab name="Main" focus=true {
            pane split_direction="vertical" {
              pane size=80 {
                pane name="Check" {
                  command "npm"
                  args "run" "check:watch"
                }
                pane name="Run" {
                  command "devenv"
                  args "up"
                }
              }
              pane {
                name "Editor"
                focus true
                command "vim"
              }
            }
          }
          tab name="Lazygit" {
            pane name="Lazygit" borderless=true {
              command "lazygit"
            }
          }
        }
      '';

      xdg.configFile."zellij/layouts/sveltekit-mini.kdl".text = ''
        layout {
          default_tab_template {
            pane size=1 borderless=true {
              plugin location="zellij:tab-bar"
            }
            children
            pane size=2 borderless=true {
              plugin location="zellij:status-bar"
            }
          }
          tab name="Processes" {
            pane split_direction="vertical" {
              pane name="Check" {
                command "npm"
                args "run" "check:watch"
              }
              pane name="Run" {
                command "devenv"
                args "up"
              }
            }
          }
          tab name="Main" focus=true {
            pane {
              name "Editor"
              focus true
              command "vim"
            }
          }
          tab name="Lazygit" {
            pane name="Lazygit" borderless=true {
              command "lazygit"
            }
          }
        }
      '';
    };
  };
}
