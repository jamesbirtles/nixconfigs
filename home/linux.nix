{ ... }:
{
  imports = [
    ./base.nix
    ./programs.nix
    ./programs-linux.nix
    ./accounts.nix
  ];

  home-manager.users.james = {
    imports = [
      ./dconf.nix
    ];
  };
}
