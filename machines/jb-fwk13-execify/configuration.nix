{ config, pkgs, outPath, ... }:
{
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.initrd.luks.devices."luks-caf0a56f-856c-4415-a635-88c3a05e141a".device = "/dev/disk/by-uuid/caf0a56f-856c-4415-a635-88c3a05e141a";
  networking.hostName = "jb-fwk13-execify"; 

  system.stateVersion = "24.05";

  services.clamav.daemon.enable = true;
  services.clamav.scanner.enable = true;
  services.clamav.updater.enable = true;

  system.autoUpgrade = {
    enable = true;
    flake = outPath;
    flags = [
      "--update-input"
      "nixpkgs"
      "--commit-lock-file"
      "-L" # print build logs
    ];
    dates = "02:00";
    randomizedDelaySec = "45min";
  };

  # Wake up for updates and clamav scans
  services.autosuspend = {
    enable = true;
    checks.LogindSessionsIdle.enabled = true;
    wakeups.clamav = {
      enabled = true;
      class = "SystemdTimer";
      match = "clamdscan";
    };
    wakeups.autoupgrade = {
      enabled = true;
      class = "SystemdTimer";
      match = "nixos-upgrade";
    };
  };
}
