{ config, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    hcloud
    vultr-cli
    infisical
    devenv
  ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nixpkgs.config.allowUnfree = true;

  environment.shellAliases = {
    nb = "sudo nixos-rebuild switch --flake .#";
    nu = "nix flake update --commit-lock-file";
    nix-repair = "sudo nix-store --repair --verify --check-contents"; # Use when having weird issues with source being not found or whatever
    kit = "zellij --layout sveltekit";
    mkit = "zellij --layout sveltekit-mini";
  };

  programs.zsh = {
    enable = true;
  };

  fonts.packages = with pkgs; [
    nerd-fonts.fira-code
    fira-code
    fira-code-symbols
  ];

  programs.gnupg.agent.enable = true;

  time.timeZone = "Europe/London";
}
