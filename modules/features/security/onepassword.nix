{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.features.security.onepassword;
in
{
  options.features.security.onepassword = {
    enable = lib.mkEnableOption "1Password password manager";
  };

  config = lib.mkIf cfg.enable {
    programs._1password.enable = true;
    programs._1password-gui = {
      enable = true;
      polkitPolicyOwners = [ "james" ];
    };
  };
}
