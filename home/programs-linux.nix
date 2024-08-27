{ ... }:
{
  home-manager.users.james = {
    programs.obs-studio = {
      enable = true;
    };
  };
  virtualisation.docker.enable = true;
}
