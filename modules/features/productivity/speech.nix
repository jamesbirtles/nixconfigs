{
  config,
  lib,
  pkgs,
  whisrs,
  ...
}:
let
  cfg = config.features.productivity.speech;
  whisrsPkg = whisrs.packages.${pkgs.stdenv.hostPlatform.system}.default;
in
{
  options.features.productivity.speech = {
    enable = lib.mkEnableOption "Speech-to-text voice input (whisrs)";
  };

  config = lib.mkIf cfg.enable {
    # whisrs synthesizes keystrokes via /dev/uinput; its udev rule grants the
    # `input` group access.
    services.udev.packages = [ whisrsPkg ];
    users.users.james.extraGroups = [ "input" ];

    home-manager.users.james = {
      home.packages = [ whisrsPkg ];

      # Ships contrib/whisrs.service (user unit) in lib/systemd/user.
      systemd.user.services.whisrs = {
        Unit = {
          Description = "whisrs dictation daemon";
          After = [ "graphical-session.target" ];
          PartOf = [ "graphical-session.target" ];
        };
        Service = {
          ExecStart = "${whisrsPkg}/bin/whisrsd";
          Restart = "on-failure";
        };
        Install.WantedBy = [ "graphical-session.target" ];
      };
    };
  };
}
