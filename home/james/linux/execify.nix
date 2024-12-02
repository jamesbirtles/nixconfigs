{ pkgs, ... }:
let
  drata-agent = pkgs.callPackage ../../../apps/drata-agent.nix {};
  autostartPrograms = with pkgs; [
    slack
    _1password-gui
    drata-agent
  ];
in
{
  home.packages = with pkgs; [
    slack
    zoom-us
    zed-editor
    ngrok
    nodejs_20
    corepack_20
    jetbrains-toolbox
    drata-agent
    stripe-cli
  ];
  home.file = builtins.listToAttrs (map
    (pkg:
      {
        name = ".config/autostart/" + pkg.pname + ".desktop";
        # I'm not fussed about overwriting autostart files...
        force = true;
        value =
          if pkg ? desktopItem then {
            # Application has a desktopItem entry.
            # Assume that it was made with makeDesktopEntry, which exposes a
            # text attribute with the contents of the .desktop file
            text = pkg.desktopItem.text;
          } else {
            # Application does *not* have a desktopItem entry. Try to find a
            # matching .desktop name in /share/applications
            source = (pkg + "/share/applications/" + pkg.pname + ".desktop");
          };
      })
    autostartPrograms);
}
