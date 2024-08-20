{
  description = "A simple nix darwin flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/release-24.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs";
    darwin = {
      url = "github:lnl7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
      inputs.home-manager.follows = "home-manager";
      inputs.nix-darwin.follows = "darwin";
    };
    pnpm2nix = {
      url = "github:nzbr/pnpm2nix-nzbr";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
  };


  outputs = inputs @ { self, nixpkgs, darwin, home-manager, nixvim, pnpm2nix, nixos-hardware, ... }: {
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
        ./home/darwin.nix
        ./vim.nix
        home-manager.darwinModules.home-manager
        nixvim.nixDarwinModules.nixvim
      ];
    };

    nixosConfigurations.jb-fwk16 = nixpkgs.lib.nixosSystem rec {
      system = "x86_64-linux";
      specialArgs = {
        pnpm2nix = pnpm2nix.packages.${system};
      };
      modules = [
        ./machines/jb-fwk16/hardware-configuration.nix
        ./configuration.nix
        ./shared.nix
        ./home/linux.nix
        ./vim.nix
        home-manager.nixosModules.home-manager
        nixvim.nixosModules.nixvim
        nixos-hardware.nixosModules.framework-16-7040-amd
      ];
    };
  };
}
