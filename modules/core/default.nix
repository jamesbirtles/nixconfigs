{ ... }:
{
  imports = [
    ./nix.nix
    ./users.nix
    ./locale.nix
    ./networking.nix
    ./fonts.nix
  ];

  services.fstrim.enable = true;

  zramSwap.enable = true;
}
