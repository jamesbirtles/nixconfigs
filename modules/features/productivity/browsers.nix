{
  config,
  lib,
  pkgs,
  firefox-gnome-theme ? null,
  zen-browser,
  ...
}:
let
  cfg = config.features.productivity.browsers;
in
{
  options.features.productivity.browsers = {
    enable = lib.mkEnableOption "Web browsers (Firefox, Chromium, Zen)";
  };

  config = lib.mkIf cfg.enable {
    programs.chromium.enable = true;

    environment.systemPackages = with pkgs; [
      zen-browser
    ];

    # Home-manager configuration for user james
    home-manager.users.james = {
      home.file.".mozilla/firefox/default/chrome/firefox-gnome-theme".source =
        if firefox-gnome-theme != null then
          firefox-gnome-theme
        else
          throw "firefox-gnome-theme input is required when browsers feature is enabled";

      programs.firefox.enable = true;
      programs.firefox.profiles.default = {
        id = 0;
        name = "default";
        isDefault = true;
        userChrome = ''
          @import "firefox-gnome-theme/userChrome.css";
        '';
        userContent = ''
          @import "firefox-gnome-theme/userContent.css";
        '';
        settings = {
          # Firefox gnome theme
          "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
          "browser.uidensity" = 0;
          "svg.context-properties.content.enabled" = true;
          "browser.theme.dark-private-windows" = false;
          "widget.gtk.rounded-bottom-corners.enabled" = true;
          "gnomeTheme.hideSingleTab" = true;
        };
      };
    };
  };
}
