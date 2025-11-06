{ pkgs, ... }:
let
  launchPrefix = "uwsm app -- ";
in
{
  # App Launcher
  programs.walker = {
    enable = true;
    runAsService = true;
    config = {
      app_launch_prefix = launchPrefix;
      providers.default = [ "desktopapplications" "calc" ];
    };
  };

  # Top bar
  programs.ashell = {
    enable = true;
    systemd = {
      enable = true;
      target = "wayland-session@Hyprland.target";
    };
    settings = {
      app_launcher_cmd = "walker";
      modules = {
        left = [ ["AppLauncher" "Workspaces"] ];
        center = [ "Clock" "MediaPlayer" ];
        right = [ ["Tray" "Privacy" "Updates" "SystemInfo" "Settings"] ];
      };
      clock.format = "%A %-d %B %X";
      updates = {
        check_cmd = "check-updates --ignore darwin";
        update_cmd = "hyprctl dispatch exec '[float; center; size 70% 70%; workspace special]' 'ghostty -e update-system' &";
      };
      workspaces.visibility_mode = "MonitorSpecific";
    };
  };

  wayland.windowManager.hyprland = {
    enable = true;
    # set the Hyprland and XDPH packages to null to use the ones from the NixOS module
    package = null;
    portalPackage = null;
    systemd.enable = false;

    settings = {
      "$mod" = "SUPER";
      "$terminal" = "com.mitchellh.ghostty.desktop";
      "$web" = "chromium-browser.desktop";
      "$launcher" = "walker";
      "$editor" = "dev.zed.Zed.desktop";

      gesture = "3, horizontal, workspace";

      exec-once = "systemctl --user enable --now hyprpolkitagent.service";

      monitorv2 = [
        {
          output = "desc:Samsung Electric Company S27C900P H1AK500000";
          mode = "preferred";
          position = "0x0";
          scale = "auto";
        }
        {
          output = "desc:BOE 0x0BC9";
          mode = "preferred";
          position = "auto-left";
          scale = "auto";
        }
        {
          output = "desc:Acer Technologies SA240Y T92EE0012410";
          mode = "preferred";
          position = "auto-right";
          scale = "auto";
        }
      ];

      input = {
        kb_layout = "gb";
        touchpad = {
          natural_scroll = true;
          # two fingers for right click, three for middle
          clickfinger_behavior = true;
        };
      };

      bindd = [
        "$mod, M, Quit hyprland, exec, uwsm stop"
        "$mod, Q, Quit current app, killactive,"
        "$mod, F, Toggle floating window, exec, hyprctl activewindow -j | jq -r '.floating' | grep -q false && hyprctl dispatch togglefloating && hyprctl dispatch resizeactive exact 70% 70% && hyprctl dispatch centerwindow || hyprctl dispatch togglefloating"

        "$mod, H, Move focus left, movefocus, l"
        "$mod, J, Move focus up, movefocus, d"
        "$mod, K, Move focus down, movefocus, u"
        "$mod, L, Move focus right, movefocus, r"

        "$mod ALT, H, Move window left, movewindow, l"
        "$mod ALT, J, Move window up, movewindow, d"
        "$mod ALT, K, Move window down, movewindow, u"
        "$mod ALT, L, Move window right, movewindow, r"

        "CTRL ALT, left, Workspace left, workspace, r-1"
        "CTRL ALT, right, Workspace right, workspace, r+1"
        "$mod, escape, Toggle scratchpad, togglespecialworkspace,"

        # App shortcuts
        "$mod, space, Open launcher, exec, ${launchPrefix} $launcher"
        "$mod, T, Open Terminal, exec, ${launchPrefix} $terminal"
        "$mod, B, Open Web Browser, exec, ${launchPrefix} $web"
        "$mod, E, Open Editor, exec, ${launchPrefix} $editor"
      ];

      bindmd = [
        "$mod, mouse:272, Move the window, movewindow"
        "$mod, mouse:273, Resize the window, resizewindow"
      ];

      # Works when locked and repeats
      bindel = [
        ", XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"
        ", XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
      ];

      # Works when locked
      bindl = [
        ", XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
        ", XF86AudioPlay, exec, playerctl play-pause"
        ", XF86AudioPrev, exec, playerctl previous"
        ", XF86AudioNext, exec, playerctl next"
      ];
    };
  };
}

