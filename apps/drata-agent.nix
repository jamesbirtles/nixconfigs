{ pkgs, ... }:
let

  pname = "drata-agent";
  version = "3.6.1";
  name = "${pname}-${version}";

  src = pkgs.fetchurl {
    url = "https://github.com/drata/agent-releases/releases/download/v${version}/Drata-Agent-linux.AppImage";
    hash = "sha256-ZHwQdw1XXOeiYCrRHffQXCD3uS9FnYBZcjUQah3sLzY=";
  };

  appimageContents = pkgs.appimageTools.extractType2 { inherit name src; };

  drata-agent = pkgs.appimageTools.wrapType2 rec {
    inherit name pname version src;

    extraInstallCommands = ''
      install -m 444 -D ${appimageContents}/${pname}.desktop -t $out/share/applications
      sed -i 's/AppRun --no-sandbox/drata-agent/g' $out/share/applications/${pname}.desktop
      cp -r ${appimageContents}/usr/share/icons $out/share
    '';
  };
in
  drata-agent