{
  config,
  lib,
  pkgs,
  noctalia,
  ...
}:
let
  cfg = config.features.desktop.niri;
in
{
  imports = [ ./gnome-compat.nix ];

  options.features.desktop.niri = {
    enable = lib.mkEnableOption "Niri scrollable-tiling Wayland compositor";
  };

  config = lib.mkIf cfg.enable {
    # System-level configuration
    programs.niri = {
      enable = true;
      package = pkgs.niri;
    };

    environment.sessionVariables = {
      NIXOS_OZONE_WL = "1";
      ZED_WINDOW_DECORATIONS = "server";
    };

    services.logind.settings.Login = {
      HandleLidSwitch = "suspend";
      HandleLidSwitchDocked = "ignore";
      HandleLidSwitchExternalPower = "suspend";
    };

    security.pam.services.swaylock = { };
    security.polkit.enable = true;
    systemd.user.services.niri-flake-polkit.enable = false; # handled by noctalia polkit-agent plugin

    # systemd tmpfiles rule for xdg-desktop-portal (for screensharing)
    systemd.tmpfiles.rules = [
      "L+ /usr/libexec/xdg-desktop-portal - - - - ${pkgs.xdg-desktop-portal}/libexec/xdg-desktop-portal"
    ];

    environment.systemPackages = with pkgs; [
      xwayland-satellite
      brightnessctl
      wl-clipboard
      gpu-screen-recorder
      # screen-toolkit plugin dependencies
      grim
      slurp
      tesseract
      imagemagick
      zbar
      curl
      translate-shell
      wf-recorder
      ffmpeg
      gifski
    ];

    # Home-manager configuration for user james
    home-manager.users.james = {
      imports = [
        ./home.nix
        noctalia.homeModules.default
      ];

      # noctalia-qs is archived and no longer compiles against Qt 6.12. The
      # patch is quickshell's upstream fix (5d5d49873f, "use MOC includes
      # instead of opaque pointer definitions") rebased onto the fork. Goes
      # away with the move to noctalia v5, which doesn't use quickshell.
      programs.noctalia-shell.package =
        let
          inherit (pkgs.stdenv.hostPlatform) system;
        in
        noctalia.packages.${system}.default.override {
          quickshell = noctalia.inputs.noctalia-qs.packages.${system}.default.overrideAttrs (old: {
            patches = (old.patches or [ ]) ++ [ ./noctalia-qs-qt-6.12.patch ];
          });
        };
    };
  };
}
