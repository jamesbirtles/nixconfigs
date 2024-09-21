# Generated via dconf2nix: https://github.com/gvolpe/dconf2nix
{ lib, ... }:

with lib.hm.gvariant;

{
  dconf.settings = {
    "org/gnome/control-center" = {
      last-panel = "keyboard";
    };

    "org/gnome/desktop/input-sources" = {
      xkb-options = [ "caps:escape" ];
    };

    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
      show-battery-percentage = true;
      toolkit-accessibility = false;
    };

    "org/gnome/desktop/peripherals/mouse" = {
      accel-profile = "flat";
    };

    "org/gnome/desktop/peripherals/touchpad" = {
      click-method = "fingers";
      speed = 0.338346;
      tap-to-click = false;
      two-finger-scrolling-enabled = true;
    };

    "org/gnome/mutter" = {
      experimental-features = [ "scale-monitor-framebuffer" ];
    };

    "org/gnome/nautilus/preferences" = {
      migrated-gtk-settings = true;
    };

    "org/gnome/shell" = {
      favorite-apps = [ "firefox.desktop" "org.gnome.Nautilus.desktop" "Alacritty.desktop" "org.gnome.Geary.desktop" "org.gnome.Calendar.desktop" ];
    };

    "org/gnome/shell/world-clocks" = {
      locations = [];
    };

    "org/gtk/settings/file-chooser" = {
      date-format = "regular";
      location-mode = "path-bar";
      show-hidden = false;
      show-size-column = true;
      show-type-column = true;
      sidebar-width = 157;
      sort-column = "name";
      sort-directories-first = false;
      sort-order = "ascending";
      type-format = "category";
      window-position = mkTuple [ 26 23 ];
      window-size = mkTuple [ 1231 902 ];
    };

  };
}
