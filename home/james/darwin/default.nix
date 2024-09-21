{ ... }:
{
  imports = [
    ../../config.nix
  ];

  users.users.james = {
    name = "james";
    home = "/Users/james";
  };

  home-manager.users.james = {
    home.stateVersion = "23.11";
    xdg.enable = true;

    imports = [
      ../programs.nix
      ./programs.nix
    ];
  };
}
