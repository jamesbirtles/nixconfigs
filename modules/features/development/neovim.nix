# NixOS glue for the editor: enable NixVim and pull in the portable nvim module
# at the repo root (the same module the standalone `nix run .#nvim` package
# builds from). The actual config lives in ../../../nvim; this file only holds
# the NixOS-level bits that can't live in a portable NixVim module.
{
  environment.variables.EDITOR = "nvim";

  programs.nixvim = {
    enable = true;
    imports = [ ../../../nvim ];
  };
}
