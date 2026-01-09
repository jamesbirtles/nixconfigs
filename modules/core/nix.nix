{ config, lib, pkgs, ... }:
{
  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    trusted-users = [ "root" "@wheel" ];
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

  nixpkgs.config.allowUnfree = true;

  programs.nix-ld.enable = true;

  boot.kernelPackages = pkgs.linuxPackages_6_18;
  boot.loader.systemd-boot.configurationLimit = 10;

  security.pam.loginLimits = [
    {
      domain = "*";
      type = "soft";
      item = "nofile";
      value = "65536";
    }
  ];
}
