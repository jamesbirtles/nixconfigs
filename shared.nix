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
    nb = "sudo nixos-rebuild switch --flake .#";
    kit = "zellij --layout sveltekit";
    mkit = "zellij --layout sveltekit-mini";
  };

  programs.zsh = {
    enable = true;
  };

  fonts.packages = with pkgs; [
    nerdfonts
    fira-code
    fira-code-symbols
  ];

  programs.gnupg.agent.enable = true;

  time.timeZone = "Europe/London";
}
