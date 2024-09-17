{ config, pkgs, ... }:
{
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.initrd.luks.devices."luks-a48122fc-9424-4da0-99c6-a0180a322bc2".device = "/dev/disk/by-uuid/a48122fc-9424-4da0-99c6-a0180a322bc2";
  networking.hostName = "jb-fwk16";

  # TODO: could I get away without one?
  # services.displayManager.sddm.enable = true;
  # services.displayManager.sddm.wayland.enable = true;
  # services.displayManager.enable = false;
  programs.hyprland.enable = true;
  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  services.desktopManager.plasma6.enable = true;

  users.users.james = {
    isNormalUser = true;
    description = "James Birtles";
    extraGroups = [ "networkmanager" "wheel" "docker" ];
    packages = with pkgs; [
      bitwarden-desktop
      chromium
    ];
  };

  programs.partition-manager.enable = true;
  programs.steam.enable = true;

  environment.systemPackages = with pkgs; [
    mangohud
    gamemode
  ];

  system.stateVersion = "24.05";
}
