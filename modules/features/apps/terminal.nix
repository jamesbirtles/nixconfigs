{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.features.apps.terminal;
in
{
  options.features.apps.terminal = {
    enable = lib.mkEnableOption "Terminal Apps and Tools";
  };

  config = lib.mkIf cfg.enable {
    # System-level packages
    environment.systemPackages = with pkgs; [
      jq
      rclone
      claude-code
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
