{
  description = "James's NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixvim = {
      url = "github:nix-community/nixvim";
    };
    pnpm2nix = {
      url = "github:nzbr/pnpm2nix-nzbr";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    firefox-gnome-theme = {
      url = "github:rafaelmardojai/firefox-gnome-theme";
      flake = false;
    };
    nix-vscode-extensions = {
      url = "github:nix-community/nix-vscode-extensions";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
    elephant.url = "github:abenz1267/elephant";
    walker = {
      url = "github:abenz1267/walker";
      inputs.elephant.follows = "elephant";
    };
    niri.url = "github:sodiboo/niri-flake";
    ashell.url = "github:MalpenZibo/ashell";
    browser-previews.url = "github:nix-community/browser-previews";
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      nixvim,
      pnpm2nix,
      nixos-hardware,
      firefox-gnome-theme,
      nix-vscode-extensions,
      zen-browser,
      walker,
      niri,
      ashell,
      browser-previews,
      ...
    }:
    let
      mkSystem =
        hostname:
        {
          hardware ? null,
        }:
        let
          hwModule = if builtins.isString hardware then nixos-hardware.nixosModules.${hardware} else hardware;
        in
        nixpkgs.lib.nixosSystem rec {
          system = "x86_64-linux";
          specialArgs = {
            inherit walker;
            pnpm2nix = pnpm2nix.packages.${system};
            ashell = ashell.packages.${system}.default;
            firefox-gnome-theme = firefox-gnome-theme;
            vscode-extensions = nix-vscode-extensions.extensions.${system}.vscode-marketplace;
            zen-browser = zen-browser.packages.${system}.default;
            google-chrome-dev = browser-previews.packages.${system}.google-chrome-dev;
            outPath = self.outPath;
          };
          modules = [
            ./hosts/${hostname}
            ./vim.nix
            home-manager.nixosModules.home-manager
            nixvim.nixosModules.nixvim
            niri.nixosModules.niri
          ]
          ++ nixpkgs.lib.optional (hwModule != null) hwModule;
        };
    in
    {
      nixosConfigurations = nixpkgs.lib.mapAttrs mkSystem {
        jb-fwk16.hardware = "framework-16-7040-amd";
        jb-fwk13.hardware = "framework-13-7040-amd";
        jb-thinkpad-t16.hardware = "lenovo-thinkpad-p16s-amd-gen4";
        jamesbox = {};
      };
    };
}
