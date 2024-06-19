# Hyprland/Desktop environment set up for linux
{ pkgs, ... }:
{
  security.pam.services.hyprlock = {};
  home-manager.users.james = {
    programs.waybar = {
      enable = true;
      systemd = {
        enable = true;
        target = "hyprland-session.target";
      };
      settings = [{
        layer = "top";
        position = "bottom";
        height = 30;
        spacing = 4;
        modules-left = ["hyprland/workspaces"];
        modules-center = ["hyprland/window"];
        modules-right = [
          "tray"
          "cpu"
          "memory"
          "network"
          "power-profiles-daemon"
          "battery"
          "clock"
        ];
        battery = {
          states = {
            warning = 30;
            critical = 15;
          };
          format = "{capacity}% {icon}";
          format-charging = "{capacity}% 󰃨";
          format-plugged = "{capacity}% ";
          format-alt = "{time} {icon}";
          format-icons = ["" "" "" "" ""];
        };
        power-profiles-daemon = {
          format = "{icon}";
          tooltip-format = "Power profile: {profile}";
          tooltip = true;
          format-icons = {
            default = "";
            performance = "󱡮";
            balanced = "";
            power-saver = "";
          };
        };
        cpu = {
          format = "{usage}% ";
        };
        memory = {
          format = "{}% ";
        };
        network = {
          format-wifi = "{essid} ({signalstrength}%) ";
          format-ethernet = "{ipaddr}/{cidr} 󰈀";
          tooltip-format = "{ifname} {ipaddr} via {gwaddr} 󱂇";
          format-linked = "{ifname} (no ip) ";
          format-disconnected = "disconnected 󰖪";
          format-alt = "{ifname}: {ipaddr}/{cidr}";
        };
      }];
    };
    services.mako.enable = true;
    xdg.portal = {
      enable = true;
      extraportals = [ pkgs.xdg-desktop-portal-hyprland ];
      config.common.default = "*";
    };
    services.hyprpaper = {
      enable = true;
      settings = {
        ipc = "on";
      };
    };
    programs.rofi = {
      enable = true;
      package = pkgs.rofi-wayland;
    };
    services.avizo.enable = true;
    programs.hyprlock.enable = true;
    wayland.windowmanager.hyprland = {
      enable = true;
      systemd.enable = true;
      systemd.enablexdgautostart = true;
      settings = {
        monitor = "edp-2, 2560x1600@165, 0x0, 1";
        "$mod" = "super";
        "$browser" = "firefox";
        "$terminal" = "alacritty";
        "$menu" = "rofi -show drun -show-icons";
        bind = [
          "$mod, q, exec, $terminal"
          "$mod, c, killactive"
          "$mod, m, exit"
          "$mod, r, exec, $menu"
          "$mod, b, exec, $browser"

          "$mod, left, movefocus, l"
          "$mod, right, movefocus, r"
          "$mod, up, movefocus, u"
          "$mod, down, movefocus, d"

          "$mod shift, left, swapwindow, l"
          "$mod shift, right, swapwindow, r"
          "$mod shift, up, swapwindow, u"
          "$mod shift, down, swapwindow, d"

          "$mod, kp_left, resizeactive, -100 0"
          "$mod, kp_right, resizeactive, 100 0"
          "$mod, kp_up, resizeactive, 0 -100"
          "$mod, kp_down, resizeactive, 0 100"

          "$mod, n, workspace, +1"
          "$mod, p, workspace, -1"

          ", xf86audiomute, exec, volumectl toggle-mute"
        ];
        binde = [
          ", xf86audioraisevolume, exec, volumectl -u up"
          ", xf86audiolowervolume, exec, volumectl -u down"
          ", xf86monbrightnessup, exec, lightctl up"
          ", xf86monbrightnessdown, exec, lightctl down"
        ];
        input = {
          kb_layout = "gb";
          kb_variant = "";
          repeat_delay = 400;
          touchpad = {
            scroll_factor = 0.2;
            natural_scroll = true;
            clickfinger_behavior = true;
          };
        };
        gestures = {
          workspace_swipe = true;
        };
        windowrulev2 = [
          "suppressevent maximize, class:.*"
        ];
        general = {
          layout = "master";
        };
        decoration = {
          rounding = 4;
        };
        animation = [
          "workspaces, 1, 2, default"
        ];
        exec = [
          "gsettings set org.gnome.desktop.interface gtk-theme \"your_dark_gtk3_theme\""
          "gsettings set org.gnome.desktop.interface color-scheme \"prefer-dark\""
        ];
        env = ["qt_qpa_platformtheme,qt6ct"];
        # misc.disable_hyprland_logo = true;
        misc = {
          force_default_wallpaper = 0;
          focus_on_activate = true;
        };
      };
    };
  };
}
