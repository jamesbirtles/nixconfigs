{ pkgs, ... }:
{
  accounts.email.accounts.personal = {
    primary = true;
    address = "james@birtles.dev";
    userName = "james@birtles.dev";
    realName = "James Birtles";
    passwordCommand = "rbw get \"Migadu Email\"";
    # aerc.enable = true;
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
}
