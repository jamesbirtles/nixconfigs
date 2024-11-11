{ pkgs, ... }:
let

  pname = "zen";
  version = "1.0.1-a.19";
  name = "${pname}-${version}";

  src = pkgs.fetchurl {
    url = "https://github.com/zen-browser/desktop/releases/download/${version}/${pname}-specific.AppImage";
    hash = "sha256-qAPZ4VyVmeZLRfL0kPHF75zyrSUFHKQUSUcpYKs3jk8=";
  };

  appimageContents = pkgs.appimageTools.extractType2 { inherit name src; };

  zen = pkgs.appimageTools.wrapType2 rec {
    inherit name pname version src;

    extraInstallCommands = ''
      install -m 444 -D ${appimageContents}/${pname}.desktop -t $out/share/applications
      cp -r ${appimageContents}/usr/share/icons $out/share
    '';
  };
in
{
  environment.systemPackages = [ zen ];
}
