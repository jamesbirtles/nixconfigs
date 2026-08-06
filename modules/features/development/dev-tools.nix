{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.features.development.dev-tools;
in
{
  options.features.development.dev-tools = {
    enable = lib.mkEnableOption "Development tools (devenv, prisma, nil, nixd, python3)";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      devenv
      prisma
      nil
      nixd
      python3
    ];

    home-manager.users.james.programs.zsh.initContent = ''
      eval "$(devenv hook zsh)"
    '';
  };
}
