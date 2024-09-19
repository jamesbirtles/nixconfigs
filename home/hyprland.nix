# Hyprland Desktop environment set up for linux
{ pkgs, ... }:
{
  security.pam.services.hyprlock = {};
  programs.hyprland.enable = true;
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
          format-wifi = "{essid} ({signalStrength}%) ";
          format-ethernet = "{ipaddr}/{cidr} 󰈀";
          tooltip-format = "{ifname} {ipaddr} via {gwaddr} 󱂇";
          format-linked = "{ifname} (No IP) ";
          format-disconnected = "Disconnected 󰖪";
          format-alt = "{ifname}: {ipaddr}/{cidr}";
        };
      }];
    };
    services.mako.enable = true;
    xdg.portal = {
      enable = true;
      extraPortals = [ pkgs.xdg-desktop-portal-hyprland ];
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
    wayland.windowManager.hyprland = {
      enable = true;
      systemd.enable = true;
      systemd.enableXdgAutostart = true;
      settings = {
        monitor = [
          "eDP-2, 2560x1600@165, 0x0, 1"
          "desc:Samsung Electric Company S27C900P H1AK500000,highres,auto,1.6"
          "desc:BNQ BenQ PD2705Q H8L01078019,highres,auto,1.5"
          ",highres,auto,1"
        ];
        "$mod" = "SUPER";
        "$browser" = "firefox";
        "$terminal" = "alacritty";
        "$menu" = "rofi -show drun -show-icons";
        bind = [
          "$mod, Q, exec, $terminal"
          "$mod, C, killactive"
          "$mod, M, exit"
          "$mod, R, exec, $menu"
          "$mod, B, exec, $browser"

          "$mod, left, movefocus, l"
          "$mod, right, movefocus, r"
          "$mod, up, movefocus, u"
          "$mod, down, movefocus, d"

          "$mod SHIFT, left, swapwindow, l"
          "$mod SHIFT, right, swapwindow, r"
          "$mod SHIFT, up, swapwindow, u"
          "$mod SHIFT, down, swapwindow, d"

          "$mod, kp_left, resizeactive, -100 0"
          "$mod, kp_right, resizeactive, 100 0"
          "$mod, kp_up, resizeactive, 0 -100"
          "$mod, kp_down, resizeactive, 0 100"

          "$mod, N, workspace, +1"
          "$mod, P, workspace, -1"

          ", XF86AudioMute, exec, volumectl toggle-mute"
        ];
        binde = [
          ", XF86AudioRaiseVolume, exec, volumectl -u up"
          ", XF86AudioLowerVolume, exec, volumectl -u down"
          ", XF86MonBrightnessUp, exec, lightctl up"
          ", XF86MonBrightnessDown, exec, lightctl down"
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
          "gsettings set org.gnome.desktop.interface gtk-theme \"YOUR_DARK_GTK3_THEME\""
          "gsettings set org.gnome.desktop.interface color-scheme \"prefer-dark\""
        ];
        env = ["QT_QPA_PLATFORMTHEME,qt6ct"];
        # misc.disable_hyprland_logo = true;
        misc = {
          force_default_wallpaper = 0;
          focus_on_activate = true;
        };
      };
    };
  };
}
