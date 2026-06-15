{
  description = "James's NixOS configuration";

  nixConfig = {
    extra-substituters = [
      "https://noctalia.cachix.org"
      "https://cache.garnix.io"
    ];
    extra-trusted-public-keys = [
      "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4="
      "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g="
    ];
  };

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
    niri.url = "github:sodiboo/niri-flake";
    ashell.url = "github:MalpenZibo/ashell";
    noctalia = {
      # Stay on legacy-v4 until v5 is fully released.
      url = "github:noctalia-dev/noctalia-shell/legacy-v4";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.noctalia-qs.follows = "noctalia-qs";
    };
    noctalia-qs = {
      url = "github:noctalia-dev/noctalia-qs";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    browser-previews.url = "github:nix-community/browser-previews";
    nix-alien.url = "github:thiagokokada/nix-alien";
    zed-editor.url = "github:jamesbirtles/zed-flake/stable";
    handy = {
      url = "github:cjpais/Handy/v0.8.3";
      inputs.nixpkgs.follows = "nixpkgs";
    };
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
      niri,
      ashell,
      noctalia,
      noctalia-qs,
      browser-previews,
      nix-alien,
      zed-editor,
      handy,
      ...
    }:
    let
      mkSystem =
        hostname:
        {
          hardware ? null,
        }:
        let
          # `hardware` may be a nixos-hardware module name (string), an inline
          # module, or a list of either — letting a host compose generic
          # nixos-hardware modules itself instead of relying on a board-specific
          # wrapper.
          toModule = h: if builtins.isString h then nixos-hardware.nixosModules.${h} else h;
          hwModules =
            if hardware == null then [ ]
            else if builtins.isList hardware then map toModule hardware
            else [ (toModule hardware) ];
        in
        nixpkgs.lib.nixosSystem rec {
          system = "x86_64-linux";
          specialArgs = {
            inherit noctalia handy;
            pnpm2nix = pnpm2nix.packages.${system};
            ashell = ashell.packages.${system}.default;
            firefox-gnome-theme = firefox-gnome-theme;
            vscode-extensions = nix-vscode-extensions.extensions.${system}.vscode-marketplace;
            zen-browser = zen-browser.packages.${system}.default;
            google-chrome-dev = browser-previews.packages.${system}.google-chrome-dev;
            nix-alien = nix-alien.packages.${system}.nix-alien;
            zed-editor = zed-editor.packages.${system}.default;
            outPath = self.outPath;
          };
          modules = [
            ./hosts/${hostname}
            ./vim.nix
            home-manager.nixosModules.home-manager
            nixvim.nixosModules.nixvim
            niri.nixosModules.niri
          ]
          ++ hwModules;
        };
    in
    {
      # Standalone NixVim package from the shared ./nvim module (also imported
      # by NixOS via programs.nixvim.imports). Run with `nix run .#nvim`. Built
      # against NixVim's pinned nixpkgs rather than this flake's.
      packages = nixpkgs.lib.genAttrs [ "x86_64-linux" "aarch64-darwin" ] (
        system: {
          nvim =
            (nixvim.lib.evalNixvim {
              inherit system;
              modules = [ ./nvim ];
            }).config.build.package;
        }
      );

      nixosConfigurations = nixpkgs.lib.mapAttrs mkSystem {
        jb-fwk16.hardware = "framework-16-7040-amd";
        jb-fwk13.hardware = "framework-13-7040-amd";
        jb-thinkpad-t16.hardware = "lenovo-thinkpad-p16s-amd-gen4";
        # Not the p16s board module (this is a P16 Gen2 with an i7-13850HX and a
        # discrete RTX 3500 Ada) — compose the generic modules ourselves and set
        # NVIDIA explicitly in the host. See hosts/jb-thinkpad-p16/default.nix.
        jb-thinkpad-p16.hardware = [
          "lenovo-thinkpad"
          "common-cpu-intel-cpu-only"
          "common-gpu-nvidia-nonprime"
          "common-pc-ssd"
        ];
        thinkpad-server.hardware = "lenovo-thinkpad-t470s";
        jamesbox = {};
        jamesb-darwin = {};
      };
    };
}
