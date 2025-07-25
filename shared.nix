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
    lg = "lazygit";
    nb = "rm -f ~/.config/autostart/drata-agent.desktop.hm-backup && sudo nixos-rebuild switch --flake .#";
    nix-repair = "sudo nix-store --repair --verify --check-contents"; # Use when having weird issues with source being not found or whatever
    kit = "zellij --layout sveltekit";
    mkit = "zellij --layout sveltekit-mini";
    execify = "zellij --layout execify";
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
