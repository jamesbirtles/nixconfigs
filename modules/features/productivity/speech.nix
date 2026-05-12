{
  config,
  lib,
  pkgs,
  handy,
  ...
}:
let
  cfg = config.features.productivity.speech;
  handyPkg = handy.packages.${pkgs.stdenv.hostPlatform.system}.handy;
in
{
  options.features.productivity.speech = {
    enable = lib.mkEnableOption "Speech-to-text voice input (handy)";
  };

  config = lib.mkIf cfg.enable {
    programs.ydotool.enable = true;
    users.users.james.extraGroups = [ "ydotool" ];

    home-manager.users.james = {
      imports = [ handy.homeManagerModules.default ];

      home.packages = [
        handyPkg
      ];

      home.file.".local/bin/handy-type".source = pkgs.writeShellScript "handy-type" ''
        exec ${pkgs.ydotool}/bin/ydotool type --key-delay 0 --key-hold 1 -- "$1"
      '';

      services.handy = {
        enable = true;
        package = handyPkg;
      };
    };
  };
}
