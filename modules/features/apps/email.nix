{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.features.apps.email;
in
{
  options.features.apps.email = {
    enable = lib.mkEnableOption "Email account configuration";
  };

  config = lib.mkIf cfg.enable {
    # Home-manager configuration for user james
    home-manager.users.james = {
      accounts.email.accounts.personal = {
        primary = true;
        address = "james@birtles.dev";
        userName = "james@birtles.dev";
        realName = "James Birtles";
        passwordCommand = "rbw get \"Migadu Email\"";
        imap = {
          host = "imap.migadu.com";
          port = 993;
          tls.enable = true;
        };
        smtp = {
          host = "smtp.migadu.com";
          port = 465;
          tls.enable = true;
        };
      };
    };
  };
}
