{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.features.development.cloud-tools;
in
{
  options.features.development.cloud-tools = {
    enable = lib.mkEnableOption "Cloud and infrastructure tools (hcloud, vultr-cli, infisical)";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      hcloud
      vultr-cli
      infisical
    ];
  };
}
