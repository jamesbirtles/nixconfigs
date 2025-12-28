{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.features.development.dev-tools;
in
{
  options.features.development.dev-tools = {
    enable = lib.mkEnableOption "Development tools (prisma, nil, nixd, python3, playwright)";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      prisma
      nil
      nixd
      python3
      python3Packages.playwright
    ];

    environment.sessionVariables = {
      PLAYWRIGHT_BROWSERS_PATH = "${pkgs.playwright-driver.browsers}";
      PLAYWRIGHT_SKIP_VALIDATE_HOST_REQUIREMENTS = "true";
    };
  };
}
