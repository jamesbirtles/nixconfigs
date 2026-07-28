{ config, lib, ... }:
{
  # Declare GNOME compatibility for apps that sniff the desktop environment.
  #
  # Chromium does not ask whether a secret store exists; it infers one from the
  # desktop name (base/nix/xdg_util.cc, GetDesktopEnvironment). "niri" matches
  # nothing it knows, and the Chromium bundled in Electron then maps that unknown
  # environment to the `basic_text` backend — plaintext with a hardcoded key — so
  # `safeStorage.isEncryptionAvailable()` is false and Claude Desktop reports
  # "install and unlock a system keyring". Verified against its own binary:
  #
  #   XDG_CURRENT_DESKTOP=niri        (unknown) -> BASIC_TEXT, no backend
  #   XDG_CURRENT_DESKTOP=niri:GNOME  GNOME     -> GNOME_LIBSECRET, key found
  #
  # Current Google Chrome already falls back to libsecret on an unknown desktop,
  # so it was never affected; this is specifically about Electron apps.
  #
  # Nothing is actually missing: gnome-keyring runs and owns
  # org.freedesktop.secrets (GDM's PAM starts and unlocks it, and every host
  # running niri also enables GNOME). Only the inference fails.
  #
  # XDG_CURRENT_DESKTOP is a colon-separated list in priority order and consumers
  # take the first name they recognise, so appending GNOME says "treat me as
  # GNOME if you don't know niri" without displacing niri for anyone who does.
  # xdg-desktop-portal walks the same list and still matches niri-portals.conf
  # first, which is what pins its Secret backend to gnome-keyring.
  #
  # Known cost: Chromium reads proxy settings from org.gnome.system.proxy via
  # gsettings instead of $http_proxy, and OnlyShowIn=GNOME desktop entries become
  # visible in launchers.
  #
  # GDM sets this from DesktopNames= in niri.desktop, so it cannot be set ahead of
  # the session. niri-session re-execs the login shell before
  # `systemctl --user import-environment`, making login shell init the one point
  # where amending it still reaches systemd, D-Bus activation, niri, and every app
  # the session spawns. Guarded so GNOME sessions and SSH logins are untouched.
  config = lib.mkIf config.features.desktop.niri.enable {
    environment.loginShellInit = ''
      if [ "$XDG_CURRENT_DESKTOP" = "niri" ]; then
        export XDG_CURRENT_DESKTOP=niri:GNOME
      fi
    '';
  };
}
