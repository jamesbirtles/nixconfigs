{
  config,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    ./desktop.nix
  ];

  features = {
    communication.discord.enable = lib.mkDefault true;
    communication.slack.enable = lib.mkDefault true;
    communication.thunderbird.enable = lib.mkDefault true;

    services.lldpd.enable = lib.mkDefault true;

    development.techex.enable = lib.mkDefault true;

    productivity.work-hours.enable = lib.mkDefault true;
  };

  home-manager.users.james = lib.mkIf config.features.desktop.niri.enable {
    programs.niri.settings = {
      workspaces = {
        "1" = { };
        "2" = { };
        "3" = { };
      };

      spawn-at-startup = [
        { command = [ "zen-beta" ]; }
        { command = [ "ghostty" "--class=com.mitchellh.ghostty.ws1" ]; }
        { command = [ "zed" ]; }
        { command = [ "ghostty" "--class=com.mitchellh.ghostty.ws2" ]; }
        { command = [ "slack" ]; }
        { command = [ "chromium" "--profile-directory=Default" "--app-id=cifhbcnohmdccbgoicgdjpfamggdegmo" ]; }
      ];

      window-rules = [
        { matches = [ { app-id = "^zen-beta$"; } ]; open-on-workspace = "1"; }
        { matches = [ { app-id = "^com\\.mitchellh\\.ghostty\\.ws1$"; } ]; open-on-workspace = "1"; }
        { matches = [ { app-id = "^dev\\.zed\\.Zed$"; } ]; open-on-workspace = "2"; }
        { matches = [ { app-id = "^com\\.mitchellh\\.ghostty\\.ws2$"; } ]; open-on-workspace = "2"; }
        { matches = [ { app-id = "^Slack$"; } ]; open-on-workspace = "3"; }
        {
          matches = [ { app-id = "^chrome-cifhbcnohmdccbgoicgdjpfamggdegmo-Default$"; title = "Microsoft Teams"; } ];
          open-on-workspace = "3";
        }
        {
          matches = [ { app-id = "^chrome-cifhbcnohmdccbgoicgdjpfamggdegmo-Default$"; } ];
          excludes = [ { title = "Microsoft Teams"; } ];
          open-floating = true;
        }
      ];
    };
  };
}
