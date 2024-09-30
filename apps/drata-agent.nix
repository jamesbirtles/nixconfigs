{ pkgs, lib, stdenv, ... }:
let
  drata-agent = pkgs.stdenv.mkDerivation rec {
    name = "drata-agent-desktop-item";
    dontBuild = true;
    unpackPhase = "true";

    desktopItem = pkgs.makeDesktopItem {
      name = "drata-agent";
      exec = "${pkgs.steam-run}/bin/steam-run \"/home/james/apps/drata-agent/opt/Drata Agent/drata-agent\" %U";
      # genericName = "Web Browser";
      # categories = "Application;Network;WebBrowser;";
      startupWMClass = "Drata Agent";
      desktopName = "Drata Agent";
      mimeTypes = [
        "x-scheme-handler/auth-drata-agent"
      ];
    };

    installPhase = ''
      mkdir -p $out/share
      cp -r ${desktopItem}/share/applications $out/share
    '';
  };
in
{
  environment.systemPackages = [ pkgs.steam-run drata-agent ];
}
