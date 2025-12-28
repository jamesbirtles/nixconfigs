# Generated via dconf2nix: https://github.com/gvolpe/dconf2nix
{ lib, ... }:

with lib.hm.gvariant;

{
  dconf.settings = {
    "apps/seahorse/listing" = {
      keyrings-selected = [ "gnupg://" ];
    };

    "apps/seahorse/windows/key-manager" = {
      height = 476;
      width = 600;
    };

    "ca/desrt/dconf-editor" = {
      saved-pathbar-path = "/org/gnome/";
      saved-view = "/org/gnome/";
      window-height = 500;
      window-is-maximized = false;
      window-width = 540;
    };

    "com/belmoussaoui/Obfuscate" = {
      is-maximized = false;
    };

    "org/gnome/Console" = {
      custom-font = "BerkeleyMono Nerd Font 10";
      last-window-maximised = false;
      last-window-size = mkTuple [
        1541
        875
      ];
      use-system-font = false;
    };

    "org/gnome/Extensions" = {
      window-height = 1178;
      window-width = 1106;
    };

    "org/gnome/Geary" = {
      ask-open-attachment = true;
      compose-as-html = true;
      formatting-toolbar-visible = false;
      images-trusted-domains = [ "ui.com" ];
      migrated-config = true;
      optional-plugins = [ "sent-sound" ];
      run-in-background = true;
      window-height = 1423;
      window-maximize = true;
      window-width = 2006;
    };

    "org/gnome/Loupe" = {
      show-properties = false;
    };

    "org/gnome/Snapshot" = {
      capture-mode = "video";
      enable-audio-recording = true;
      is-maximized = false;
      last-camera-id = "Logitech StreamCam (V4L2)";
      play-shutter-sound = true;
      show-composition-guidelines = false;
      window-height = 640;
      window-width = 800;
    };

    "org/gnome/TextEditor" = {
      last-save-directory = "file:///home/james/Documents";
    };

    "org/gnome/Totem" = {
      active-plugins = [
        "vimeo"
        "apple-trailers"
        "open-directory"
        "screensaver"
        "autoload-subtitles"
        "skipto"
        "screenshot"
        "movie-properties"
        "variable-rate"
        "save-file"
        "recent"
        "mpris"
        "rotation"
      ];
      subtitle-encoding = "UTF-8";
    };

    "org/gnome/Weather" = {
      locations = [ ];
      window-height = 494;
      window-maximized = false;
      window-width = 992;
    };

    "org/gnome/baobab/ui" = {
      is-maximized = false;
      window-size = mkTuple [
        960
        600
      ];
    };

    "org/gnome/calendar" = {
      active-view = "month";
      week-view-zoom-level = 0.5340000000000017;
      window-maximized = true;
      window-size = mkTuple [
        768
        600
      ];
    };

    "org/gnome/clocks/state/window" = {
      maximized = false;
      panel-id = "world";
      size = mkTuple [
        870
        690
      ];
    };

    "org/gnome/control-center" = {
      last-panel = "multitasking";
      window-state = mkTuple [
        1503
        970
        false
      ];
    };

    "org/gnome/desktop/app-folders" = {
      folder-children = [
        "Utilities"
        "YaST"
        "Pardus"
      ];
    };

    "org/gnome/desktop/app-folders/folders/Pardus" = {
      categories = [ "X-Pardus-Apps" ];
      name = "X-Pardus-Apps.directory";
      translate = true;
    };

    "org/gnome/desktop/app-folders/folders/Utilities" = {
      apps = [
        "gnome-abrt.desktop"
        "gnome-system-log.desktop"
        "nm-connection-editor.desktop"
        "org.gnome.baobab.desktop"
        "org.gnome.Connections.desktop"
        "org.gnome.DejaDup.desktop"
        "org.gnome.Dictionary.desktop"
        "org.gnome.DiskUtility.desktop"
        "org.gnome.Evince.desktop"
        "org.gnome.FileRoller.desktop"
        "org.gnome.fonts.desktop"
        "org.gnome.Loupe.desktop"
        "org.gnome.seahorse.Application.desktop"
        "org.gnome.tweaks.desktop"
        "org.gnome.Usage.desktop"
        "vinagre.desktop"
      ];
      categories = [ "X-GNOME-Utilities" ];
      name = "X-GNOME-Utilities.directory";
      translate = true;
    };

    "org/gnome/desktop/app-folders/folders/YaST" = {
      categories = [ "X-SuSE-YaST" ];
      name = "suse-yast.directory";
      translate = true;
    };

    "org/gnome/desktop/background" = {
      color-shading-type = "solid";
      picture-options = "zoom";
      picture-uri = "file:///run/current-system/sw/share/backgrounds/gnome/fold-l.jxl";
      picture-uri-dark = "file:///run/current-system/sw/share/backgrounds/gnome/fold-d.jxl";
      primary-color = "#26a269";
      secondary-color = "#000000";
    };

    "org/gnome/desktop/calendar" = {
      show-weekdate = false;
    };

    "org/gnome/desktop/input-sources" = {
      mru-sources = [
        (mkTuple [
          "xkb"
          "gb"
        ])
      ];
      sources = [
        (mkTuple [
          "xkb"
          "gb"
        ])
      ];
      xkb-options = [ "caps:escape" ];
    };

    "org/gnome/desktop/interface" = {
      clock-show-seconds = true;
      clock-show-weekday = true;
      color-scheme = "prefer-dark";
      gtk-enable-primary-paste = false;
      show-battery-percentage = true;
      toolkit-accessibility = false;
    };

    "org/gnome/desktop/notifications" = {
      application-children = [
        "org-gnome-settings"
        "org-gnome-nautilus"
        "org-gnome-geary"
        "slack"
        "org-gnome-software"
        "microsoft-edge"
        "gnome-power-panel"
        "zoom"
      ];
      show-banners = true;
    };

    "org/gnome/desktop/notifications/application/code-url-handler" = {
      application-id = "code-url-handler.desktop";
    };

    "org/gnome/desktop/notifications/application/code" = {
      application-id = "code.desktop";
    };

    "org/gnome/desktop/notifications/application/cursor" = {
      application-id = "cursor.desktop";
    };

    "org/gnome/desktop/notifications/application/dev-zed-zed" = {
      application-id = "dev.zed.Zed.desktop";
    };

    "org/gnome/desktop/notifications/application/firefox" = {
      application-id = "firefox.desktop";
    };

    "org/gnome/desktop/notifications/application/gnome-power-panel" = {
      application-id = "gnome-power-panel.desktop";
    };

    "org/gnome/desktop/notifications/application/jetbrains-fleet" = {
      application-id = "jetbrains-fleet.desktop";
    };

    "org/gnome/desktop/notifications/application/jetbrains-toolbox" = {
      application-id = "jetbrains-toolbox.desktop";
    };

    "org/gnome/desktop/notifications/application/microsoft-edge" = {
      application-id = "microsoft-edge.desktop";
    };

    "org/gnome/desktop/notifications/application/org-gnome-baobab" = {
      application-id = "org.gnome.baobab.desktop";
    };

    "org/gnome/desktop/notifications/application/org-gnome-calendar" = {
      application-id = "org.gnome.Calendar.desktop";
    };

    "org/gnome/desktop/notifications/application/org-gnome-characters" = {
      application-id = "org.gnome.Characters.desktop";
    };

    "org/gnome/desktop/notifications/application/org-gnome-console" = {
      application-id = "org.gnome.Console.desktop";
    };

    "org/gnome/desktop/notifications/application/org-gnome-evolution-alarm-notify" = {
      application-id = "org.gnome.Evolution-alarm-notify.desktop";
    };

    "org/gnome/desktop/notifications/application/org-gnome-fileroller" = {
      application-id = "org.gnome.FileRoller.desktop";
    };

    "org/gnome/desktop/notifications/application/org-gnome-geary" = {
      application-id = "org.gnome.Geary.desktop";
    };

    "org/gnome/desktop/notifications/application/org-gnome-nautilus" = {
      application-id = "org.gnome.Nautilus.desktop";
    };

    "org/gnome/desktop/notifications/application/org-gnome-settings" = {
      application-id = "org.gnome.Settings.desktop";
    };

    "org/gnome/desktop/notifications/application/org-gnome-software" = {
      application-id = "org.gnome.Software.desktop";
    };

    "org/gnome/desktop/notifications/application/slack" = {
      application-id = "slack.desktop";
    };

    "org/gnome/desktop/notifications/application/zen" = {
      application-id = "zen.desktop";
    };

    "org/gnome/desktop/notifications/application/zoom" = {
      application-id = "Zoom.desktop";
    };

    "org/gnome/desktop/peripherals/mouse" = {
      accel-profile = "flat";
      speed = -0.157895;
    };

    "org/gnome/desktop/peripherals/touchpad" = {
      click-method = "fingers";
      speed = 0.338346;
      tap-to-click = false;
      two-finger-scrolling-enabled = true;
    };

    "org/gnome/desktop/screensaver" = {
      color-shading-type = "solid";
      picture-options = "zoom";
      picture-uri = "file:///run/current-system/sw/share/backgrounds/gnome/fold-l.jxl";
      primary-color = "#26a269";
      secondary-color = "#000000";
    };

    "org/gnome/desktop/search-providers" = {
      sort-order = [
        "org.gnome.Contacts.desktop"
        "org.gnome.Documents.desktop"
        "org.gnome.Nautilus.desktop"
      ];
    };

    "org/gnome/desktop/session" = {
      idle-delay = mkUint32 300;
    };

    "org/gnome/desktop/sound" = {
      event-sounds = true;
      theme-name = "__custom";
    };

    "org/gnome/epiphany" = {
      ask-for-default = false;
    };

    "org/gnome/epiphany/state" = {
      is-maximized = true;
      window-size = mkTuple [
        2560
        1408
      ];
    };

    "org/gnome/file-roller/dialogs/extract" = {
      height = 800;
      recreate-folders = true;
      skip-newer = false;
      width = 1000;
    };

    "org/gnome/file-roller/file-selector" = {
      show-hidden = false;
      sidebar-size = 300;
      sort-method = "name";
      sort-type = "ascending";
      window-size = mkTuple [
        (-1)
        (-1)
      ];
    };

    "org/gnome/file-roller/listing" = {
      list-mode = "as-folder";
      name-column-width = 65;
      show-path = false;
      sort-method = "name";
      sort-type = "ascending";
    };

    "org/gnome/file-roller/ui" = {
      sidebar-width = 200;
      window-height = 480;
      window-width = 600;
    };

    "org/gnome/gnome-system-monitor" = {
      current-tab = "processes";
      show-dependencies = false;
      show-whose-processes = "user";
      window-height = 1208;
      window-width = 1681;
    };

    "org/gnome/gnome-system-monitor/proctree" = {
      col-26-visible = false;
      col-26-width = 0;
    };

    "org/gnome/mutter" = {
      dynamic-workspaces = true;
      experimental-features = [ "scale-monitor-framebuffer" ];
      workspaces-only-on-primary = true;
    };

    "org/gnome/nautilus/preferences" = {
      default-folder-viewer = "icon-view";
      migrated-gtk-settings = true;
      search-filter-time-type = "last_modified";
    };

    "org/gnome/nautilus/window-state" = {
      initial-size = mkTuple [
        890
        550
      ];
      initial-size-file-chooser = mkTuple [
        890
        550
      ];
    };

    "org/gnome/nm-applet/eap/ac2f5a5d-155c-42f8-80fc-b3b8ae48d686" = {
      ignore-ca-cert = false;
      ignore-phase2-ca-cert = false;
    };

    "org/gnome/nm-applet/eap/ee289eb9-1329-4f3c-aea8-d62f864d6bd0" = {
      ignore-ca-cert = false;
      ignore-phase2-ca-cert = false;
    };

    "org/gnome/portal/filechooser/1password" = {
      last-folder-path = "/home/james/Downloads";
    };

    "org/gnome/portal/filechooser/microsoft-edge" = {
      last-folder-path = "/home/james/Documents";
    };

    "org/gnome/portal/filechooser/slack" = {
      last-folder-path = "/home/james/Pictures";
    };

    "org/gnome/portal/filechooser/transient" = {
      last-folder-path = "/home/james/Downloads";
    };

    "org/gnome/settings-daemon/plugins/color" = {
      night-light-enabled = false;
      night-light-schedule-automatic = false;
      night-light-temperature = mkUint32 3652;
    };

    "org/gnome/settings-daemon/plugins/media-keys" = {
      custom-keybindings = [ ];
    };

    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
      binding = "<Ctrl><Alt><Shift>H";
      command = "dbus-send --session --dest=com.zoom.HotKeyService --type=method_call /com/zoom/HotKeyListener com.zoom.HotKeyListener.keyPressed int64:55834574920 string:\"<Ctrl><Alt><Shift>H\"";
      name = "ZMHKey55834574920";
    };

    "org/gnome/settings-daemon/plugins/power" = {
      sleep-inactive-ac-type = "suspend";
    };

    "org/gnome/shell" = {
      disable-user-extensions = false;
      disabled-extensions = [
        "trayIconsReloaded@selfmade.pl"
        "apps-menu@gnome-shell-extensions.gcampax.github.com"
        "native-window-placement@gnome-shell-extensions.gcampax.github.com"
        "places-menu@gnome-shell-extensions.gcampax.github.com"
        "drive-menu@gnome-shell-extensions.gcampax.github.com"
        "system-monitor@gnome-shell-extensions.gcampax.github.com"
        "user-theme@gnome-shell-extensions.gcampax.github.com"
        "window-list@gnome-shell-extensions.gcampax.github.com"
        "windowsNavigator@gnome-shell-extensions.gcampax.github.com"
        "workspace-indicator@gnome-shell-extensions.gcampax.github.com"
      ];
      enabled-extensions = [ "appindicatorsupport@rgcjonas.gmail.com" ];
      favorite-apps = [
        "microsoft-edge.desktop"
        "org.gnome.Nautilus.desktop"
        "slack.desktop"
        "dev.zed.Zed.desktop"
        "com.mitchellh.ghostty.desktop"
        "org.gnome.Geary.desktop"
      ];
      last-selected-power-profile = "power-saver";
      welcome-dialog-last-shown-version = "46.4";
    };

    "org/gnome/shell/weather" = {
      automatic-location = true;
      locations = [ ];
    };

    "org/gnome/shell/world-clocks" = {
      locations = [ ];
    };

    "org/gnome/software" = {
      check-timestamp = mkInt64 1747729028;
      first-run = false;
      flatpak-purge-timestamp = mkInt64 1747657184;
      install-timestamp = mkInt64 1743409694;
      update-notification-timestamp = mkInt64 1747645507;
    };

    "org/gnome/tweaks" = {
      show-extensions-notice = false;
    };

    "org/gtk/gtk4/settings/file-chooser" = {
      date-format = "regular";
      location-mode = "path-bar";
      show-hidden = false;
      sidebar-width = 140;
      sort-column = "name";
      sort-directories-first = true;
      sort-order = "ascending";
      type-format = "category";
      view-type = "list";
      window-size = mkTuple [
        859
        366
      ];
    };

    "org/gtk/settings/color-chooser" = {
      custom-colors = [
        (mkTuple [
          0.984314
          0.737255
          0.533333
          1.0
        ])
        (mkTuple [
          0.960784
          0.760784
          6.6667e-2
          1.0
        ])
      ];
      selected-color = mkTuple [
        true
        0.960784
        0.760784
        6.6667e-2
        1.0
      ];
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
      window-position = mkTuple [
        26
        23
      ];
      window-size = mkTuple [
        1231
        902
      ];
    };

    "system/locale" = {
      region = "en_GB.UTF-8";
    };

  };
}
