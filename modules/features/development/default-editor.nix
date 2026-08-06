# Single owner of $EDITOR. The editor modules install editors; this module
# decides which one shells and git hand a buffer to.
{ config, lib, ... }:
let
  editors = [
    { id = "nvim"; command = "nvim"; }
    # `--wait` blocks until the buffer is closed, which git and friends require.
    { id = "zed"; command = "zeditor --wait"; }
  ];
  choice = lib.findFirst (e: e.id == config.features.development.defaultEditor) null editors;
in
{
  options.features.development.defaultEditor = lib.mkOption {
    type = lib.types.enum (map (e: e.id) editors);
    default = "nvim";
    description = ''
      Editor that $EDITOR points at. Headless hosts should stay on a terminal
      editor: Zed is installed there only to serve remote connections and has
      no GUI session to open into.
    '';
  };

  config.environment.variables.EDITOR = choice.command;
}
