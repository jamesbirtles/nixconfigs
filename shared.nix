{ config, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    git
    gnupg
    gh
    ripgrep
    fd
    ansible
    pandoc
    hcloud
    texliveSmall
    vultr-cli
    infisical
    btop
    bat
    devenv
  ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  environment.shellAliases = {
    lg = "lazygit";
    nb = "sudo nixos-rebuild switch --flake .#";
    kit = "zellij --layout sveltekit";
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
