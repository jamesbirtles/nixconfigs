{
  config,
  pkgs,
  lib,
  ...
}:
{
  imports = [
    # Import the niri home-manager module to get config.lib.niri.actions
  ];

  home.file.".icons/default".source = "${pkgs.apple-cursor}/share/icons/macOS";

  # Noctalia Shell
  programs.noctalia = {
    enable = true;
    systemd.enable = true;
    # niri-flake's polkit agent is disabled in ./default.nix.
    settings.shell.polkit_agent = true;
  };

  programs.niri.settings = {
    debug.honor-xdg-activation-with-invalid-serial = true;
    prefer-no-csd = true;
    input.keyboard.xkb = {
      layout = "gb";
      options = "caps:escape";
    };
    binds = with config.lib.niri.actions; {
      # allow-inhibiting=false: always handled by niri, never forwarded. While
      # lan-mouse captures, niri honours its shortcuts-inhibit request so Mod
      # binds forward to the remote; these keep lock/quit local regardless, and
      # the toggle is an escape hatch to reclaim niri's binds if inhibit sticks.
      "Mod+Escape" = {
        action = spawn "noctalia" "msg" "session" "lock";
        allow-inhibiting = false;
      };
      "Mod+Shift+Escape" = {
        action = quit;
        allow-inhibiting = false;
      };
      "Mod+Shift+I" = {
        action = toggle-keyboard-shortcuts-inhibit;
        allow-inhibiting = false;
      };
      "Mod+W".action = close-window;

      "Mod+F".action = toggle-window-floating;
      "Mod+R".action = switch-preset-column-width;
      "Mod+T".action = toggle-column-tabbed-display;

      "Mod+K".action = focus-window-up;
      "Mod+J".action = focus-window-down;
      "Mod+H".action = focus-column-left;
      "Mod+L".action = focus-column-right;
      "Mod+P".action = focus-workspace-up;
      "Mod+N".action = focus-workspace-down;

      "Mod+1".action = focus-window-in-column 1;
      "Mod+2".action = focus-window-in-column 2;
      "Mod+3".action = focus-window-in-column 3;
      "Mod+4".action = focus-window-in-column 4;
      "Mod+5".action = focus-window-in-column 5;
      "Mod+6".action = focus-window-in-column 6;
      "Mod+7".action = focus-window-in-column 7;
      "Mod+8".action = focus-window-in-column 8;
      "Mod+9".action = focus-window-in-column 9;

      "Mod+Alt+K".action = move-window-up;
      "Mod+Alt+J".action = move-window-down;
      "Mod+Alt+H".action = move-column-left;
      "Mod+Alt+L".action = move-column-right;
      "Mod+Alt+P".action = move-window-to-workspace-up;
      "Mod+Alt+N".action = move-window-to-workspace-down;

      "Mod+Shift+H".action = consume-or-expel-window-left;
      "Mod+Shift+L".action = consume-or-expel-window-right;

      "Mod+M".action = focus-monitor-next;
      "Mod+Alt+M".action = move-column-to-monitor-next;

      "Mod+Space".action = spawn "noctalia" "msg" "panel-toggle" "launcher";
      "Mod+Return".action = spawn "ghostty";
      "Mod+B".action = spawn "google-chrome-unstable";
      "Mod+V".action = spawn "whisrs" "toggle";
      "Mod+Ctrl+V".action = spawn "whisrs" "command";

      # Function Keys
      "XF86AudioRaiseVolume".action = spawn "noctalia" "msg" "volume-up";
      "XF86AudioLowerVolume".action = spawn "noctalia" "msg" "volume-down";
      "XF86AudioMute".action = spawn "noctalia" "msg" "volume-mute";
      "XF86MonBrightnessUp".action = spawn "noctalia" "msg" "brightness-up";
      "XF86MonBrightnessDown".action = spawn "noctalia" "msg" "brightness-down";
      "XF86AudioPlay".action = spawn "noctalia" "msg" "media" "toggle";
      "XF86AudioPrev".action = spawn "noctalia" "msg" "media" "previous";
      "XF86AudioNext".action = spawn "noctalia" "msg" "media" "next";

      "Print".action.screenshot = [ ];
    };
    layout = {
      gaps = 8;
      # struts = {
      #   left = 8;
      #   right = 8;
      # };
      border.width = 2;
      default-column-width.proportion = 0.66667;
      preset-column-widths = [
        { proportion = 0.33333; }
        { proportion = 0.5; }
        { proportion = 0.66667; }
        { proportion = 1.0; }
      ];
      background-color = "transparent";
      focus-ring = {
        active.color = "#adc7ff";
        inactive.color = "#121316";
        urgent.color = "#ffb4ab";
      };
      border = {
        active.color = "#adc7ff";
        inactive.color = "#121316";
        urgent.color = "#ffb4ab";
      };
      shadow.color = "#00000070";
      tab-indicator = {
        active.color = "#adc7ff";
        inactive.color = "#0c448e";
        urgent.color = "#ffb4ab";
      };
    };
    overview.workspace-shadow.enable = false;
    window-rules = [
      {
        matches = [
          { title = "update-system"; }
        ];
        default-column-width = {
          proportion = 0.7;
        };
        open-floating = true;
      }
      {
        # Noctalia's settings window
        matches = [
          { app-id = "dev.noctalia.Noctalia"; }
        ];
        open-floating = true;
        default-column-width.fixed = 1080;
        default-window-height.fixed = 920;
      }
      {
        geometry-corner-radius = {
          bottom-left = 8.0;
          bottom-right = 8.0;
          top-left = 8.0;
          top-right = 8.0;
        };
        clip-to-geometry = true;
      }
    ];
    layer-rules = [
      {
        matches = [
          { namespace = "^noctalia-backdrop"; }
        ];
        place-within-backdrop = true;
      }
    ];
    input = {
      touchpad = {
        click-method = "clickfinger";
      };
    };
    cursor = {
      # See top of this file for the default cursor
      theme = "default";
      size = 24;
    };
    outputs =
      let
        logicalWidth = output: builtins.floor (output.mode.width / output.scale);
        logicalHeight = output: builtins.floor (output.mode.height / output.scale);
        # Place `output` so the builtin screen sits at its bottom-right corner.
        aboveLeftOf = builtin: output: {
          x = -(logicalWidth output);
          y = logicalHeight builtin - logicalHeight output;
        };

        fw13 = {
          scale = 1.5;
          mode = {
            width = 2256;
            height = 1504;
          };
          position = {
            x = 0;
            y = 0;
          };
        };
        thinkpad-p16 = {
          scale = 1.5;
          mode = {
            width = 2560;
            height = 1600;
          };
          position = {
            x = 0;
            y = 0;
          };
          variable-refresh-rate = true;
        };

        # TODO: set builtin based on current host
        builtin = thinkpad-p16;

        samsung = {
          scale = 2.0;
          mode = {
            width = 5120;
            height = 2880;
          };
          position = aboveLeftOf builtin samsung;
        };
        tx-ultrawide = {
          scale = 1.0;
          mode = {
            width = 3440;
            height = 1440;
            refresh = 59.973;
          };
          position = {
            x = 1920;
            y = builtins.floor (builtin.mode.height / 3.0) - 1440;
          };
          # variable-refresh-rate = true;
        };
      in
      {
        "California Institute of Technology 0x160B Unknown" = thinkpad-p16;
        "Iiyama North America PL3494WQ 1214142721111" = tx-ultrawide;
        "Samsung Electric Company S27C900P H1AK500000" = samsung;
      };
  };

  # niri-flake's settings schema doesn't yet expose background-effect, so append
  # the blur rules as raw KDL while keeping `niri validate` in the build.
  xdg.configFile.niri-config.source = lib.mkForce (
    pkgs.runCommand "config.kdl"
      {
        config = ''
          ${config.programs.niri.finalConfig}

          window-rule {
              background-effect {
                  blur true
                  xray false
              }
          }

          layer-rule {
              match namespace="^noctalia-(bar-[^\"]+|notification|dock|panel|attached-panel|osd)$"
              background-effect {
                  xray false
              }
          }
        '';
        passAsFile = [ "config" ];
        buildInputs = [ config.programs.niri.package ];
      }
      ''
        niri validate -c $configPath
        cp $configPath $out
      ''
  );
}
