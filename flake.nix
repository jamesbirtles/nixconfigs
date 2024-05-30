{
  description = "A simple nix darwin flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    darwin = {
      url = "github:lnl7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
      inputs.nix-darwin.follows = "darwin";
    };
    pnpm2nix = {
      url = "github:nzbr/pnpm2nix-nzbr";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @ { self, nixpkgs, darwin, home-manager, nixvim, pnpm2nix, ... }: {
    darwinConfigurations.jamesb-macos-personal = darwin.lib.darwinSystem rec {
      system = "aarch64-darwin";
      specialArgs = {
        pnpm2nix = pnpm2nix.packages.${system};
      };
      modules = [
        # Import the previous configuration.nix we used,
        # so the old configuration file still takes effect
        ./darwin-configuration.nix
        ./shared.nix
        ./home-manager.nix
        ./vim.nix
        home-manager.darwinModules.home-manager
        nixvim.nixDarwinModules.nixvim
      ];
    };

    nixosConfigurations.mac-arm-vm = nixpkgs.lib.nixosSystem rec {
      system = "aarch64-linux";
      specialArgs = {
        pnpm2nix = pnpm2nix.packages.${system};
      };
      modules = [
        ./machines/mac-arm-vm/hardware-configuration.nix
        ./configuration.nix
        ./shared.nix
        ./home-manager.nix
        ./vim.nix
        home-manager.nixosModules.home-manager
        nixvim.nixosModules.nixvim
      ];
    };
  };
}
