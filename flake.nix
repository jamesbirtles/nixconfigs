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
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    firefox-gnome-theme = { url = "github:rafaelmardojai/firefox-gnome-theme"; flake = false; };
  };


  outputs = inputs @ {
    self,
    nixpkgs,
    darwin,
    home-manager,
    nixvim,
    pnpm2nix,
    nixos-hardware,
    firefox-gnome-theme,
    ...
  }: {
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
        ./home/james/darwin/default.nix
        ./vim.nix
        home-manager.darwinModules.home-manager
        nixvim.nixDarwinModules.nixvim
      ];
    };

    nixosConfigurations.jb-fwk16 = nixpkgs.lib.nixosSystem rec {
      system = "x86_64-linux";
      specialArgs = {
        pnpm2nix = pnpm2nix.packages.${system};
        firefox-gnome-theme = firefox-gnome-theme;
      };
      modules = [
        ./machines/jb-fwk16/hardware-configuration.nix
        ./machines/jb-fwk16/configuration.nix
        ./shared.nix
        ./shared-linux.nix
        ./home/james/linux
        ./vim.nix
        home-manager.nixosModules.home-manager
        nixvim.nixosModules.nixvim
        nixos-hardware.nixosModules.framework-16-7040-amd
      ];
    };

    nixosConfigurations.jb-fwk13-execify = nixpkgs.lib.nixosSystem rec {
      system = "x86_64-linux";
      specialArgs = {
        pnpm2nix = pnpm2nix.packages.${system};
        firefox-gnome-theme = firefox-gnome-theme;
      };
      modules = [
        ./machines/jb-fwk13-execify/hardware-configuration.nix
        ./machines/jb-fwk13-execify/configuration.nix
        ./shared.nix
        ./shared-linux.nix
        ./home/james/linux/default.nix
        ./vim.nix
        home-manager.nixosModules.home-manager
        nixvim.nixosModules.nixvim
        nixos-hardware.nixosModules.framework-13-7040-amd
      ];
    };
  };
}
