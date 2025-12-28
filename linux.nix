
{
  pkgs,
  ...
}:
{
  nix.settings = {
    trusted-users = [
      "root"
      "@wheel"
    ];
    extra-substituters = [
      "https://walker.cachix.org"
      "https://walker-git.cachix.org"
    ];
    extra-trusted-public-keys = [
      "walker.cachix.org-1:fG8q+uAaMqhsMxWjwvk0IMb4mFPFLqHjuvfwQxE4oJM="
      "walker-git.cachix.org-1:vmC0ocfPWh0S/vRAQGtChuiZBTAe4wiKDeyyXM0/7pM="
    ];
  };
  nix.gc = {
    automatic = true;
    randomizedDelaySec = "14m";
    options = "--delete-older-than 10d";
  };

  boot.kernelPackages = pkgs.linuxPackages_6_17;
  boot.loader.systemd-boot.configurationLimit = 10;

  networking.networkmanager.enable = true;
  networking.firewall.allowedTCPPortRanges = [
    {
      from = 8070;
      to = 8090;
    }
  ];
  networking.firewall.allowedUDPPortRanges = [
    {
      from = 8070;
      to = 8090;
    }
  ];

  time.timeZone = "Europe/London";
  i18n.defaultLocale = "en_GB.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_GB.UTF-8";
    LC_IDENTIFICATION = "en_GB.UTF-8";
    LC_MEASUREMENT = "en_GB.UTF-8";
    LC_MONETARY = "en_GB.UTF-8";
    LC_NAME = "en_GB.UTF-8";
    LC_NUMERIC = "en_GB.UTF-8";
    LC_PAPER = "en_GB.UTF-8";
    LC_TELEPHONE = "en_GB.UTF-8";
    LC_TIME = "en_GB.UTF-8";
  };

  environment.sessionVariables = {
    PLAYWRIGHT_BROWSERS_PATH = "${pkgs.playwright-driver.browsers}";
    PLAYWRIGHT_SKIP_VALIDATE_HOST_REQUIREMENTS = "true";
  };

  security.pam.loginLimits = [
    {
      domain = "*";
      type = "soft";
      item = "nofile";
      value = "65536";
    }
  ];

  virtualisation.docker.enable = true;

  users.defaultUserShell = pkgs.zsh;

  programs.nix-ld.enable = true;

  environment.systemPackages = with pkgs; [
    jq
    rclone
    claude-code
    prisma
    nil
    nixd
    python3
    python3Packages.playwright
    ffmpeg
    tsduck
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
    gst_all_1.gst-plugins-bad
    gst_all_1.gst-plugins-ugly
    gst_all_1.gst-plugins-rs
    gst_all_1.gst-libav
    gst_all_1.gst-vaapi
  ];
}
