# Shared home-manager configuration
{ ... }:
{
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users.james = {
      home.stateVersion = "23.11";
      xdg.enable = true;
    };
  };
}
