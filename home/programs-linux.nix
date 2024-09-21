{ firefox-gnome-theme, pkgs, ... }:
{
  home-manager.users.james = {
    programs.obs-studio = {
      enable = true;
    };

    home.file.".mozilla/firefox/default/chrome/firefox-gnome-theme".source = firefox-gnome-theme;

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
        ## Firefox gnome theme ## - https://github.com/rafaelmardojai/firefox-gnome-theme/blob/7cba78f5216403c4d2babb278ff9cc58bcb3ea66/configuration/user.js
        # (copied into here because home-manager already writes to user.js)
        "toolkit.legacyUserProfileCustomizations.stylesheets" = true; # Enable customChrome.cs
        "browser.uidensity" = 0; # Set UI density to normal
        "svg.context-properties.content.enabled" = true; # Enable SVG context-propertes
        "browser.theme.dark-private-windows" = false; # Disable private window dark theme
        "widget.gtk.rounded-bottom-corners.enabled" = true; # Enable rounded bottom window corners
        "gnomeTheme.hideSingleTab" = true;
      };
    };

    programs.rbw = {
      enable = true;
      settings.email = "jameshbirtles@gmail.com";
      settings.pinentry = pkgs.pinentry-gnome3;
    };
    programs.aerc = {
      enable = true;
      extraConfig.general.unsafe-accounts-conf = true;
    };
  };
  virtualisation.docker.enable = true;

}
