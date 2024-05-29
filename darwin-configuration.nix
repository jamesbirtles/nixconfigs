{ config, pkgs, ... }:
{
  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = with pkgs; [
    nodejs_20
    zoxide
    git
    gnupg
    gh
    ripgrep
    fd
    lazygit
    ansible
    pandoc
    hcloud
    bun
    rustup
    texliveSmall
    wrangler
    vultr-cli
    infisical
  ];

  # Use a custom configuration.nix location.
  # $ darwin-rebuild switch -I darwin-config=$HOME/.config/nixpkgs/darwin/configuration.nix
  # environment.darwinConfig = "$HOME/.config/nixpkgs/darwin/configuration.nix";

  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;
  nix.package = pkgs.nix;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];


  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;

  users.users.james = {
    name = "james";
    home = "/Users/james";
  };
  home-manager.useGlobalPkgs = true;
  home-manager.users.james = { pkgs, ... }: {
    home.stateVersion = "23.11";

    xdg.enable = true;

    programs.zsh.enable = true;
    programs.zsh.autosuggestion.enable = true;
    programs.oh-my-posh.enable = true;
    programs.oh-my-posh.useTheme = "half-life";
    programs.zsh.syntaxHighlighting.enable = true;

    programs.wezterm.enable = true;
    programs.wezterm.extraConfig = ''
      local wezterm = require("wezterm")

      local config = wezterm.config_builder()

      config.color_scheme = "Ayu Dark (Gogh)"
      config.font = wezterm.font("Berkeley Mono Variable")
      config.font_size = 18.0
      config.use_fancy_tab_bar = false
      config.hide_tab_bar_if_only_one_tab = true
      config.tab_bar_at_bottom = true

      return config
    '';

    programs.git.enable = true;
    programs.git.userEmail = "james@birtles.dev";
    programs.git.userName = "James Birtles";
    programs.git.signing.signByDefault = true;
    programs.git.signing.key = null;
    programs.git.extraConfig.push.autoSetupRemote = true;
    programs.git.extraConfig.init.defaultBranch = "main";
    programs.git.ignores = [
      ".DS_Store"
      "Desktop.ini"
      ".Spotlight-V100"
      ".Trashes"
    ];

    programs.lazygit.enable = true;
    programs.lazygit.settings.gui.showFileTree = false;
  };

  programs.zsh.enable = true;
  programs.zsh.interactiveShellInit = ''
  eval "$(zoxide init --cmd cd zsh)"
  '';

  environment.loginShell = "${pkgs.zsh}/bin/zsh -l";
  environment.variables.SHELL = "${pkgs.zsh}/bin/zsh";
  environment.shells = [pkgs.zsh];
  environment.systemPath = ["$HOME/.cargo/bin"];

  fonts.fontDir.enable = true;

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

  networking.dns = [
    "1.1.1.1"
    "1.0.0.1"
  ];
  networking.knownNetworkServices = [
    "Wi-Fi"
    "USB 10/100/1G/2.5G LAN"
  ];

  programs.gnupg.agent.enable = true;
  programs.nix-index.enable = true;
  security.pam.enableSudoTouchIdAuth = true;

  time.timeZone = "Europe/London";
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
