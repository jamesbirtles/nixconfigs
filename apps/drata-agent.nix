{ pkgs, ... }:
let

  pname = "drata-agent";
  version = "3.8.0";
  name = "${pname}-${version}";

  src = pkgs.fetchurl {
    url = "https://github.com/drata/agent-releases/releases/download/${version}/Drata-Agent-linux.AppImage";
    hash = "sha256-m1lE8eaKXzWzFIWaB+XhQDFoXX77wf8+upTV5oNktwI=";
  };

  appimageContents = pkgs.appimageTools.extractType2 { inherit pname version src; };

  drata-agent = pkgs.appimageTools.wrapType2 rec {
    inherit pname version src;

    extraInstallCommands = ''
      install -m 444 -D ${appimageContents}/${pname}.desktop -t $out/share/applications
      sed -i 's/AppRun --no-sandbox/drata-agent/g' $out/share/applications/${pname}.desktop
      cp -r ${appimageContents}/usr/share/icons $out/share
    '';
  };
in
  drata-agent
