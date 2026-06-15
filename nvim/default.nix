# Portable NixVim module, imported two ways:
#   - standalone, via `nixvim.lib.evalNixvim { modules = [ ./nvim ]; }`
#     (flake.nix `packages.<system>.nvim`, run with `nix run .#nvim`)
#   - within NixOS, via `programs.nixvim.imports = [ ./nvim ]`
{ lib, pkgs, ... }:
{
  imports = [
    ./options.nix
    ./keymaps.nix
    ./completion.nix
    ./lsp.nix
    ./ui.nix
    ./ai.nix
    ./git.nix
    ./session.nix
  ];

  viAlias = true;
  vimAlias = true;

  globals.mapleader = " ";
  globals.maplocalleader = " ";

  # Use the system clipboard for everything.
  clipboard.register = "unnamedplus";
  # wl-clipboard is Linux/Wayland only; guard it so the standalone package
  # still evaluates on macOS (jamesb-darwin).
  clipboard.providers.wl-copy.enable = lib.mkIf pkgs.stdenv.isLinux true;

  # Over SSH, fall back to OSC 52 so yanks reach the local clipboard.
  extraConfigLua = ''
    if os.getenv("SSH_TTY") then
      vim.g.clipboard = "osc52"
    end
  '';
}
