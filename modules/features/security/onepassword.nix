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
    enableGui = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable 1Password GUI application";
    };
  };

  config = lib.mkIf cfg.enable {
    programs._1password.enable = true;
    programs._1password-gui = lib.mkIf cfg.enableGui {
      enable = true;
      polkitPolicyOwners = [ "james" ];
    };
  };
}
