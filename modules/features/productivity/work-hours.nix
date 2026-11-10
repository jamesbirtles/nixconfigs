{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.features.productivity.work-hours;
  keepAwakeScript = pkgs.writeShellApplication {
    name = "work-hours-keep-awake";
    runtimeInputs = [ pkgs.coreutils ];
    text = ''
      # Syncs caffeine to the work window; triggered at both edges and at
      # session start.
      now=$(date +%s)
      if [ "$(date +%u)" -le 5 ] \
        && [ "$now" -ge "$(date -d "today 08:30" +%s)" ] \
        && [ "$now" -lt "$(date -d "today 16:30" +%s)" ]; then
        action=caffeine-enable
      else
        action=caffeine-disable
      fi

      # Retries until noctalia is ready to accept IPC.
      for _ in $(seq 1 60); do
        if noctalia msg "$action" 2>/dev/null; then
          exit 0
        fi
        sleep 1
      done

      echo "noctalia msg $action never succeeded" >&2
      exit 1
    '';
  };
in
{
  options.features.productivity.work-hours = {
    enable = lib.mkEnableOption "Enable Noctalia's caffeine during work hours (Mon-Fri 08:30-16:30)";
  };

  config = lib.mkIf cfg.enable {
    home-manager.users.james = {
      systemd.user.services.work-hours-keep-awake = {
        Unit = {
          Description = "Sync Noctalia caffeine with work hours";
          PartOf = [ "graphical-session.target" ];
          After = [ "graphical-session.target" ];
        };
        Service = {
          Type = "oneshot";
          ExecStart = "${keepAwakeScript}/bin/work-hours-keep-awake";
        };
        Install.WantedBy = [ "graphical-session.target" ];
      };

      systemd.user.timers.work-hours-keep-awake = {
        Unit.Description = "Sync Noctalia caffeine at the start and end of the work day";
        Timer = {
          OnCalendar = [
            "Mon..Fri 08:30:00"
            "Mon..Fri 16:30:00"
          ];
          Persistent = true;
          Unit = "work-hours-keep-awake.service";
        };
        Install.WantedBy = [ "timers.target" ];
      };
    };
  };
}
