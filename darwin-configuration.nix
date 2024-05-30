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

  # environment.loginShell = "${pkgs.zsh}/bin/zsh -l";
  # environment.variables.SHELL = "${pkgs.zsh}/bin/zsh";
  # environment.shells = [pkgs.zsh];
  # environment.systemPath = ["$HOME/.cargo/bin"];

  homebrew.enable = true;
  # todo: these should probably almost all be moved to using nix packages
  homebrew.brews = [
    "chezmoi"
    "pinentry-mac"
  ];
  homebrew.casks = [
    "wezterm"
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
    "spotify"
    "vial"
    "vlc"
    "whatsapp"
    "steam"
    "royal-tsx"
    "notunes"
    "discord"
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
        AppleWindowTabbingMode = "always";
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
}
