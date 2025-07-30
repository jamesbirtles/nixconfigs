{ config, pkgs, zen-browser, ... }:
{
  nix.settings.trusted-users = [ "root" "@wheel" ];
  nix.gc = {
    automatic = true;
    randomizedDelaySec = "14m";
    options = "--delete-older-than 10d";
  };

  boot.kernelPackages = pkgs.linuxPackages_6_15;
  boot.loader.systemd-boot.configurationLimit = 10;

  networking.networkmanager.enable = true;

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

  services.xserver.enable = true;
  services.xserver.xkb = {
    layout = "gb";
    variant = "";
  };

  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    PLAYWRIGHT_BROWSERS_PATH= "${pkgs.playwright-driver.browsers}";
    PLAYWRIGHT_SKIP_VALIDATE_HOST_REQUIREMENTS = "true";
  };

  # Enable the GNOME Desktop Environment.
  services.displayManager.gdm.enable = true;
  services.displayManager.gdm.wayland = true;
  services.desktopManager.gnome.enable = true;

  services.printing.enable = true;
  services.fwupd.enable = true;
  services.fprintd.enable = true;

  security.pam.loginLimits = [{
    domain = "*";
    type = "soft";
    item = "nofile";
    value = "65536";
  }];

  virtualisation.docker.enable = true;

  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  console.keyMap = "uk";
  users.defaultUserShell = pkgs.zsh;

  programs.nix-ld.enable = true;
  programs.chromium.enable = true;
  programs.steam.enable = true;
  programs._1password.enable = true;
  programs._1password-gui = {
    enable = true;
    polkitPolicyOwners = [ "james" ];
  };

  fonts.fontDir.enable = true;

  environment.systemPackages = with pkgs; [
    wl-clipboard
    dconf2nix
    mangohud
    gnomeExtensions.appindicator
    gnome-tweaks
    jq
    zen-browser
    protonup-qt
    rclone
    parsec-bin
    prusa-slicer
    vscode.fhs
  ];
  services.udev.packages = [ pkgs.gnome-settings-daemon ];
  programs.gamemode.enable = true;
  services.flatpak.enable = true;
  systemd.services.flatpak-repo = {
    wantedBy = [ "multi-user.target" ];
    path = [ pkgs.flatpak ];
    script = ''
      flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
    '';
  };
  programs.appimage = {
    enable = true;
    binfmt = true;
  };

  security.polkit.enable = true;

  # Allows zoom to find xdg-desktop-portal to allow for screensharing
  systemd.tmpfiles.rules = [
    "L+ /usr/libexec/xdg-desktop-portal - - - - ${pkgs.xdg-desktop-portal}/libexec/xdg-desktop-portal"
  ];

  # In theory I could add something like this but would need to figure out storing the password
  # instead just configure it with `rclone config`
  # environment.etc."rclone-mnt.conf".text = ''
  #   [myremote]
  #   type = sftp
  #   host = 192.0.2.2
  #   user = myuser
  #   key_file = /root/.ssh/id_rsa
  # '';

  fileSystems."/home/james/ProtonDrive" = {
    device = "protondrive:";
    fsType = "rclone";
    options = [
      "nodev"
      "nofail"
      "allow_other"
      "args2env"
      "config=/home/james/.config/rclone/rclone.conf"
    ];
  };
}
