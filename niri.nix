{
  pkgs,
  ...
}:
{
  programs.niri = {
    enable = true;
    package = pkgs.niri;
  };

  environment.sessionVariables = {
    # Force zed to use server decorations
    ZED_WINDOW_DECORATIONS = "server";
  };

  security.pam.services.swaylock = { };
  environment.systemPackages = with pkgs; [
    xwayland-satellite
    brightnessctl
  ];
}
