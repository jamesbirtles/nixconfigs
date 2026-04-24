{ config, lib, pkgs, ... }:
{
  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    trusted-users = [ "root" "@wheel" ];
    extra-substituters = [
      "https://noctalia.cachix.org"
      "https://cache.garnix.io"
    ];
    extra-trusted-public-keys = [
      "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4="
      "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g="
    ];
  };

  nix.gc = {
    automatic = true;
    dates = "weekly";
    randomizedDelaySec = "14m";
    options = "--delete-older-than 30d";
  };

  nixpkgs.config.allowUnfree = true;

  programs.nix-ld.enable = true;

  boot.kernelPackages = pkgs.linuxPackages_7_0;
  boot.loader.systemd-boot.configurationLimit = 10;

  security.pam.loginLimits = [
    {
      domain = "*";
      type = "-";
      item = "nofile";
      value = "524288";
    }
  ];

  systemd.settings.Manager.DefaultLimitNOFILE = "524288";
  systemd.user.extraConfig = ''
    DefaultLimitNOFILE=524288
  '';
}
