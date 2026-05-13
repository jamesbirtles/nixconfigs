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
      day=$(date +%u)
      if [ "$day" -gt 5 ]; then
        exit 0
      fi

      now=$(date +%s)
      start=$(date -d "today 08:30" +%s)
      end=$(date -d "today 16:30" +%s)

      if [ "$now" -lt "$start" ] || [ "$now" -ge "$end" ]; then
        exit 0
      fi

      remaining=$((end - now))

      # Retries until noctalia is ready to accept IPC.
      for _ in $(seq 1 60); do
        if noctalia-shell ipc call idleInhibitor enableFor "$remaining" 2>/dev/null; then
          exit 0
        fi
        sleep 1
      done

      echo "noctalia-shell ipc never succeeded" >&2
      exit 1
    '';
  };
in
{
  options.features.productivity.work-hours = {
    enable = lib.mkEnableOption "Enable Noctalia's KeepAwake during work hours (Mon-Fri 08:30-16:30)";
  };

  config = lib.mkIf cfg.enable {
    home-manager.users.james = {
      systemd.user.services.work-hours-keep-awake = {
        Unit = {
          Description = "Enable Noctalia KeepAwake for the remainder of the work day";
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
        Unit.Description = "Trigger work-hours KeepAwake at the start of the work day";
        Timer = {
          OnCalendar = "Mon..Fri 08:30:00";
          Persistent = true;
          Unit = "work-hours-keep-awake.service";
        };
        Install.WantedBy = [ "timers.target" ];
      };
    };
  };
}
