{ config, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    zoxide
    git
    gnupg
    gh
    ripgrep
    fd
    lazygit
    ansible
    pandoc
    hcloud
    texliveSmall
    wrangler
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
  };

  programs.zsh = {
    enable = true;
    interactiveShellInit = ''
      eval "$(zoxide init --cmd cd zsh)"
    '';
  };

  fonts.packages = with pkgs; [
    nerdfonts
    fira-code
    fira-code-symbols
  ];

  programs.gnupg.agent.enable = true;

  time.timeZone = "Europe/London";
}
