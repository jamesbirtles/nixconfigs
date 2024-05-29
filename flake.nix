{
  description = "A simple nix darwin flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-23.11-darwin";
    unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    darwin = {
      url = "github:lnl7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager/release-23.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @ { self, nixpkgs, darwin, home-manager, unstable, ... }: {
    darwinConfigurations.jamesb-macos-personal = darwin.lib.darwinSystem  {
      system = "aarch64-darwin";
      specialArgs = {
        unstable = import unstable { system = "aarch64-darwin"; };
      };
      modules = [
        # Import the previous configuration.nix we used,
        # so the old configuration file still takes effect
        ./darwin-configuration.nix
        home-manager.darwinModules.home-manager
      ];
    };
  };
}
