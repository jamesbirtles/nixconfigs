{ config, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    nodejs_20
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
    bun
    rustup
    texliveSmall
    wrangler
    vultr-cli
    infisical
    btop
    bat
  ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  environment.shellAliases = {
    lg = "lazygit";
  };

  programs.zsh = {
    enable = true;
    interactiveShellInit = ''
      eval "$(zoxide init --cmd cd zsh)"
    '';
  };

  fonts.fontDir.enable = true;

  programs.gnupg.agent.enable = true;

  time.timeZone = "Europe/London";
}
