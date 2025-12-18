{
  config,
  pkgs,
  ashell,
  ...
}:
{
  home.file.".icons/default".source = "${pkgs.apple-cursor}/share/icons/macOS";

  # App Launcher
  programs.walker = {
    enable = true;
    runAsService = true;
    config = {
      providers.default = [
        "desktopapplications"
        "calc"
      ];
    };
  };

  programs.swaylock = {
    enable = true;
    settings = {
      color = "111111";
      font-size = 24;
      indicator-idle-visible = false;
      indicator-radius = 100;
      indicator-thickness = 7;
      line-color = "000000";
      show-failed-attempts = true;

      # Colors for the indicator ring
      inside-color = "00000088";
      ring-color = "ffffff";
      line-uses-ring = false;
      key-hl-color = "5e81ac";
      bs-hl-color = "bf616a";
      separator-color = "00000000";

      # When verifying password
      inside-ver-color = "5e81ac";
      ring-ver-color = "5e81ac";

      # When password is wrong
      inside-wrong-color = "bf616a";
      ring-wrong-color = "bf616a";

      # When cleared
      inside-clear-color = "ebcb8b";
      ring-clear-color = "ebcb8b";
    };
  };

  services.swayidle = {
    enable = true;
    events.before-sleep = "swaylock -f";
    extraArgs = [ "-w" ];
    systemdTarget = "niri.service";
    timeouts = [
      {
        timeout = 300;
        command = "${pkgs.swaylock}/bin/swaylock -f";
      }
      {
        timeout = 305;
        command = "${pkgs.niri}/bin/niri msg action power-off-monitors";
        resumeCommand = "${pkgs.niri}/bin/niri msg action power-on-monitors";
      }
    ];
  };

  # Notications
  services.mako = {
    enable = true;

    settings = {
      font = "Inter 11";
      width = 380;
      height = 150;
      margin = "8";
      padding = "8";
      border-size = 4;
      border-radius = 12;
      anchor = "bottom-right";
      background-color = "#1e1e2e";
      text-color = "#cdd6f4";
      border-color = "#89b4fa";
      progress-color = "over #313244";
      icon-path = "${pkgs.papirus-icon-theme}/share/icons/Papirus-Dark";
      max-icon-size = 48;
    };

    extraConfig = ''
      [urgency=low]
      border-color=#94e2d5
      default-timeout=3000

      [urgency=normal]
      border-color=#89b4fa
      default-timeout=5000

      [urgency=high]
      border-color=#f38ba8
      default-timeout=0
      background-color=#1e1e2eF2
    '';
  };

  # OSD for volume and brightness
  services.swayosd = {
    enable = true;
    topMargin = 0.85;
    stylePath = pkgs.writeText "swayosd.css" ''
      window {
        background-color: rgba(30, 30, 46, 0.9);
        border-radius: 12px;
        border: 2px solid rgba(137, 180, 250, 0.8);
        padding: 8px;
      }

      #container {
        margin: 4px;
      }

      image {
        color: rgba(205, 214, 244, 1);
      }

      label {
        color: rgba(205, 214, 244, 1);
        font-size: 14px;
      }

      progressbar {
        min-height: 6px;
        border-radius: 3px;
      }

      trough {
        background-color: rgba(49, 50, 68, 0.8);
        border-radius: 3px;
      }

      progress {
        background-color: rgba(137, 180, 250, 1);
        border-radius: 3px;
      }
    '';
  };

  # Background Image
  systemd.user.services.swaybg = {
    Unit = {
      Description = "Wayland wallpaper daemon";
      PartOf = [ "graphical-session.target" ];
      After = [ "graphical-session.target" ];
    };

    Service = {
      ExecStart = "${pkgs.swaybg}/bin/swaybg -i ${pkgs.nixos-artwork.wallpapers.moonscape}/share/backgrounds/nixos/nix-wallpaper-moonscape.png -m fill";
      Restart = "on-failure";
    };

    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
  };

  # Top bar
  programs.ashell = {
    enable = true;
    package = ashell;
    systemd = {
      enable = true;
      target = "graphical-session.target";
    };
    settings = {
      # log_level = "ashell::modules::niri_workspaces=debug";
      app_launcher_cmd = "walker";
      position = "Bottom";
      modules = {
        left = [
          [
            "AppLauncher"
            # "NiriWorkspaces"
          ]
        ];
        center = [
          "Clock"
          "MediaPlayer"
        ];
        right = [
          [
            "Tray"
            "Privacy"
            "Updates"
            "SystemInfo"
            "Settings"
          ]
        ];
      };
      clock.format = "%A %-d %B %X";
      updates = {
        check_cmd = "check-updates --ignore darwin";
        update_cmd = "niri msg action spawn -- ghostty --title update-system -e update-system";
      };
    };
  };

  programs.niri.settings = {
    prefer-no-csd = true;
    switch-events = with config.lib.niri.actions; {
      lid-close.action = spawn "swaylock";
    };
    binds = with config.lib.niri.actions; {
      "Mod+Escape".action = spawn "swaylock";
      "Mod+Shift+Escape".action = quit;
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

      "Mod+Space".action = spawn "walker";
      "Mod+Return".action = spawn "ghostty";
      "Mod+B".action = spawn "firefox";

      # Function Keys
      "XF86AudioRaiseVolume".action = spawn "swayosd-client" "--output-volume" "raise";
      "XF86AudioLowerVolume".action = spawn "swayosd-client" "--output-volume" "lower";
      "XF86AudioMute".action = spawn "swayosd-client" "--output-volume" "mute-toggle";
      "XF86MonBrightnessUp".action = spawn "swayosd-client" "--brightness" "raise";
      "XF86MonBrightnessDown".action = spawn "swayosd-client" "--brightness" "lower";
      "XF86AudioPlay".action = spawn "playerctl" "play-pause";
      "XF86AudioPrev".action = spawn "playerctl" "previous";
      "XF86AudioNext".action = spawn "playerctl" "next";

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
          { namespace = "^wallpaper$"; }
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
        after = output: output.position.x + builtins.floor (output.mode.width / output.scale);

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
        thinkpad = {
          scale = 1.0;
          mode = {
            width = 1920;
            height = 1200;
          };
          position = {
            x = 0;
            y = 0;
          };
          variable-refresh-rate = true;
        };

        builtin = thinkpad;

        samsung = {
          scale = 2.0;
          mode = {
            width = 5120;
            height = 2889;
          };
          position = {
            x = after builtin;
            y = 0;
          };
        };
        acer = {
          scale = 1.0;
          mode = {
            width = 1920;
            height = 1080;
          };
          position = {
            x = after samsung;
            y = 0;
          };
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
            y = builtins.floor (thinkpad.mode.height / 3.0) - 1440;
          };
          # variable-refresh-rate = true;
        };
        dell-p2414h = {
          scale = 1.0;
          mode = {
            width = 1920;
            height = 1080;
            refresh = 60.0;
          };
          position = {
            x = tx-ultrawide.position.x + builtins.floor (tx-ultrawide.mode.width / 2.0);
            y = tx-ultrawide.position.y - 1080;
          };
        };
      in
      {
        "Acer Technologies SA240Y T92EE0012410" = acer;
        "Lenovo Group Limited MNG007QT1-2 Unknown" = thinkpad;
        "Iiyama North America PL3494WQ 1214142721111" = tx-ultrawide;
        "Dell Inc. DELL P2414H 4YN5344O06GL" = dell-p2414h;
        "Samsung Electric Company S27C900P H1AK500000" = samsung;
      };
  };
}
