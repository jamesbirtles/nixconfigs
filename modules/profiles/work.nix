{
  config,
  lib,
  pkgs,
  ...
}:
let
  # Chrome (and the Teams PWA) decide at launch whether a notification server
  # exists. If they start before Noctalia has claimed
  # org.freedesktop.Notifications on the session bus, they fall back to Chrome's
  # own in-window notification bubbles for the whole session. Gate their launch
  # on the bus name actually being owned rather than racing it.
  waitForNotifications = pkgs.writeShellScript "wait-for-notifications" ''
    i=0
    while [ "$i" -lt 150 ]; do
      out=$(${pkgs.dbus}/bin/dbus-send --session --print-reply \
        --dest=org.freedesktop.DBus /org/freedesktop/DBus \
        org.freedesktop.DBus.NameHasOwner \
        string:org.freedesktop.Notifications 2>/dev/null) || true
      case "$out" in
        *"boolean true"*) break ;;
      esac
      ${pkgs.coreutils}/bin/sleep 0.2
      i=$((i + 1))
    done
    exec "$@"
  '';
in
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
        { command = [ "${waitForNotifications}" "google-chrome-unstable" ]; }
        { command = [ "ghostty" "--class=com.mitchellh.ghostty.ws1" ]; }
        { command = [ "ghostty" "--class=com.mitchellh.ghostty.ws2" ]; }
        { command = [ "slack" ]; }
        { command = [ "${waitForNotifications}" "google-chrome-unstable" "--profile-directory=Default" "--app-id=ompifgpmddkgmclendfeacglnodjjndh" ]; }
      ];

      window-rules = [
        { matches = [ { app-id = "^google-chrome-unstable$"; } ]; open-on-workspace = "1"; }
        { matches = [ { app-id = "^com\\.mitchellh\\.ghostty\\.ws1$"; } ]; open-on-workspace = "1"; }
        { matches = [ { app-id = "^dev\\.zed\\.Zed$"; } ]; open-on-workspace = "2"; }
        { matches = [ { app-id = "^com\\.mitchellh\\.ghostty\\.ws2$"; } ]; open-on-workspace = "2"; }
        { matches = [ { app-id = "^Slack$"; } ]; open-on-workspace = "3"; }
        {
          matches = [ { app-id = "^chrome-ompifgpmddkgmclendfeacglnodjjndh-Default$"; title = "Microsoft Teams"; } ];
          open-on-workspace = "3";
        }
        {
          matches = [ { app-id = "^chrome-ompifgpmddkgmclendfeacglnodjjndh-Default$"; } ];
          excludes = [ { title = "Microsoft Teams"; } ];
          open-floating = true;
        }
      ];
    };
  };
}
