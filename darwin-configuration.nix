{ config, pkgs, ... }:
{
  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;
  nix.package = pkgs.nix;
  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;

  environment.shellAliases = {
    db = "darwin-rebuild switch --flake .#jamesb-macos-personal";
  };

  users.users.james = {
    name = "james";
    home = "/Users/james";
  };

  environment.loginShell = "${pkgs.zsh}/bin/zsh -l";
  environment.variables.SHELL = "${pkgs.zsh}/bin/zsh";
  environment.shells = [pkgs.zsh];
  environment.systemPath = ["$HOME/.cargo/bin"];

  homebrew.enable = true;
  # todo: these should probably almost all be moved to using nix packages
  homebrew.brews = [
    "pinentry-mac"
  ];
  homebrew.casks = [
    "basictex"
    "unnaturalscrollwheels"
    "visual-studio-code"
    "postico"
    "betterdisplay"
    "caffeine"
    "cleanshot"
    "displaylink"
    "firefox"
    "google-chrome"
    "microsoft-teams"
    "microsoft-auto-update"
    "obs"
    "orbstack"
    "postman"
    "qmk-toolbox"
    "vial"
    "whatsapp"
    "steam"
    "royal-tsx"
    "notunes"
    "balenaetcher"
  ];
  homebrew.masApps = {
    # To use the biometrics with the browser plugin, the app needs to be installed via the mac app store
    Bitwarden = 1352778147;
  };
  homebrew.onActivation.cleanup = "zap";
  homebrew.onActivation.autoUpdate = true;
  homebrew.onActivation.upgrade = true;

  networking.knownNetworkServices = [
    "Wi-Fi"
    "USB 10/100/1G/2.5G LAN"
  ];

  security.pam.enableSudoTouchIdAuth = true;

  system = {
    keyboard = {
      enableKeyMapping = true;
      remapCapsLockToEscape = true;
    };
    defaults = {
      spaces.spans-displays = false;
      menuExtraClock = {
        ShowSeconds = true;
        ShowDayOfWeek = true;
        ShowDayOfMonth = true;
        Show24Hour = true;
      };
      finder = {
        _FXShowPosixPathInTitle = true;
        ShowStatusBar = true;
        ShowPathbar = true;
        QuitMenuItem = true;
        FXPreferredViewStyle = "Nlsv"; # list view
        FXEnableExtensionChangeWarning = false;
        FXDefaultSearchScope = "SCcf"; # current folder
        CreateDesktop = false; # hide desktop icons
        AppleShowAllExtensions = true;
      };
      dock = {
        wvous-tr-corner = 13; # top right corner - lock screen
        wvous-tl-corner = 2; # top left corner - mission control
        wvous-br-corner = 4; # bottom right corner - desktop
        showhidden = true;
        show-recents = false;
        mru-spaces = false;
        autohide = true;
        autohide-delay = 0.0;
      };
      NSGlobalDomain = {
        NSAutomaticSpellingCorrectionEnabled = false;
        NSAutomaticQuoteSubstitutionEnabled = false;
        NSAutomaticPeriodSubstitutionEnabled = false;
        NSAutomaticDashSubstitutionEnabled = false;
        NSAutomaticCapitalizationEnabled = false;
        AppleWindowTabbingMode = "manual";
        AppleTemperatureUnit = "Celsius";
        AppleShowAllExtensions = true;
        AppleScrollerPagingBehavior = true;
        ApplePressAndHoldEnabled = false;
        AppleMetricUnits = 1;
        AppleInterfaceStyleSwitchesAutomatically = false;
        AppleInterfaceStyle = "Dark";
      };
      LaunchServices.LSQuarantine = false;
      CustomUserPreferences = {
        "digital.twisted.noTunes" = {
          "replacement" = "/Applications/Arc.app";
        };
      };
    };
  };

  services.yabai = {
    enable = true;
    enableScriptingAddition = true;
    config = let
      padding = 8;
    in {
      layout = "bsp";
      window_placement = "second_child";
      top_padding = padding;
      bottom_padding = padding;
      left_padding = padding;
      right_padding = padding;
      window_gap = padding;
      mouse_follows_focus = "on";
      mouse_modifier = "alt";
      # alt + left click + drag
      mouse_action1 = "move";
      # alt + right click + drag
      mouse_action2 = "resize";
      mouse_drop_action = "swap";
    };
    extraConfig = ''
      yabai -m rule --add app='^System Settings$' manage=off
      yabai -m rule --add app='^Calculator$' manage=off
    '';
  };
  environment.systemPackages = [pkgs.skhd];
  services.skhd = {
    enable = true;
    skhdConfig = ''
      alt - j : yabai -m window --focus south
      alt - k : yabai -m window --focus north
      alt - h : yabai -m window --focus west
      alt - l : yabai -m window --focus east
      alt - n : yabai -m display --focus east
      alt - p : yabai -m display --focus west

      shift + alt - j : yabai -m space --mirror x-axis
      shift + alt - h : yabai -m space --mirror y-axis
      shift + alt - l : yabai -m space --rotate 270
      shift + alt - f : yabai -m window --toggle float --grid 4:4:1:1:2:2

      shift + alt - m : yabai -m window --toggle zoom-fullscreen
      shift + alt - b : yabai -m space --balance

      cmd + alt - j : yabai -m window --swap south
      cmd + alt - k : yabai -m window --swap north
      cmd + alt - l : yabai -m window --swap east
      cmd + alt - h : yabai -m window --swap west
      cmd + alt - n : yabai -m window --display east; yabai -m display --focus east
      cmd + alt - p : yabai -m window --display west; yabai -m display --focus west

      cmd + ctrl + alt - j : yabai -m window --warp south
      cmd + ctrl + alt - k : yabai -m window --warp north
      cmd + ctrl + alt - l : yabai -m window --warp east
      cmd + ctrl + alt - h : yabai -m window --warp west

      shift + cmd + alt - l : yabai -m window --space next
      shift + cmd + alt - h : yabai -m window --space prev

      shift + cmd + alt - 1 : yabai -m window --space 1
      shift + cmd + alt - 2 : yabai -m window --space 2
      shift + cmd + alt - 3 : yabai -m window --space 3
      shift + cmd + alt - 4 : yabai -m window --space 4
      shift + cmd + alt - 5 : yabai -m window --space 5
      shift + cmd + alt - 6 : yabai -m window --space 6
      shift + cmd + alt - 7 : yabai -m window --space 7
    '';
  };
}
