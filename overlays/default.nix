{ config, pkgs, lib, ... }:

{
  nixpkgs.overlays = [
    (import ./vscode-langserver)
  ];
}
