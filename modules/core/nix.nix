{ config, lib, pkgs, ... }:
{
  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    trusted-users = [ "root" "@wheel" ];
    extra-substituters = [
      "https://noctalia.cachix.org"
    ];
    extra-trusted-public-keys = [
      "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4="
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
