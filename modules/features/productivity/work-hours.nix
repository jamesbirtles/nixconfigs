{
  config,
  lib,
  pkgs,
  noctalia,
  ...
}:
let
  cfg = config.features.productivity.work-hours;
  noctaliaShell = "${noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default}/bin/noctalia-shell";
  keepAwakeScript = pkgs.writeShellApplication {
    name = "work-hours-keep-awake";
    runtimeInputs = [ pkgs.coreutils pkgs.procps ];
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

      # Address the running noctalia by PID so IPC keeps working after a
      # noctalia upgrade mid-session — our wrapper's QS_CONFIG_PATH no
      # longer matches the running shell's. Empty QS_CONFIG_PATH bypasses
      # qs's config-based instance lookup, which conflicts with --pid.
      # Also retries until noctalia is up — niri spawns it asynchronously.
      for _ in $(seq 1 60); do
        pid=$(pgrep -u "$UID" -nf 'bin/quickshell$' || true)
        if [ -n "$pid" ]; then
          if env QS_CONFIG_PATH="" ${noctaliaShell} ipc --pid "$pid" call idleInhibitor enableFor "$remaining" 2>/dev/null; then
            exit 0
          fi
        fi
        sleep 1
      done

      echo "noctalia-shell IPC never became available" >&2
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
