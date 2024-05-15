{
  description = "A simple nix darwin flake";

  inputs = {
    nixpkgs-darwin.url = "github:nixos/nixpkgs/nixpkgs-23.11-darwin";
    darwin = {
      url = "github:lnl7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs-darwin";
    };
    home-manager = {
      url = "github:nix-community/home-manager/release-23.11";
      inputs.nixpkgs.follows = "nixpkgs-darwin";
    };
  };

  outputs = inputs @ { self, nixpkgs, darwin, home-manager, ... }: {
    # TODO: what about my work mac?
    darwinConfigurations.jamesb-macos-personal = darwin.lib.darwinSystem  {
      system = "aarch64-darwin";
      modules = [
        # Import the previous configuration.nix we used,
        # so the old configuration file still takes effect
        ./darwin-configuration.nix
        home-manager.darwinModules.home-manager
      ];
    };
  };
}