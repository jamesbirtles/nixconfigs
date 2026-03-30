{
  config,
  pkgs,
  lib,
  ...
}:
{
  imports = [
    # Import the niri home-manager module to get config.lib.niri.actions
  ];

  home.file.".icons/default".source = "${pkgs.apple-cursor}/share/icons/macOS";

  # Noctalia Shell
  programs.noctalia-shell = {
    enable = true;
    settings = {
      settingsVersion = 59;

      appLauncher = {
        autoPasteClipboard = false;
        clipboardWatchImageCommand = "wl-paste --type image --watch cliphist store";
        clipboardWatchTextCommand = "wl-paste --type text --watch cliphist store";
        clipboardWrapText = true;
        customLaunchPrefix = "";
        customLaunchPrefixEnabled = false;
        density = "default";
        enableClipPreview = true;
        enableClipboardChips = true;
        enableClipboardHistory = false;
        enableClipboardSmartIcons = true;
        enableSessionSearch = true;
        enableSettingsSearch = true;
        enableWindowsSearch = true;
        iconMode = "tabler";
        ignoreMouseInput = false;
        overviewLayer = false;
        pinnedApps = [ ];
        position = "center";
        screenshotAnnotationTool = "";
        showCategories = true;
        showIconBackground = false;
        sortByMostUsed = true;
        terminalCommand = "alacritty -e";
        viewMode = "list";
      };

      audio = {
        mprisBlacklist = [ ];
        preferredPlayer = "";
        spectrumFrameRate = 30;
        spectrumMirrored = true;
        visualizerType = "linear";
        volumeFeedback = true;
        volumeFeedbackSoundFile = "";
        volumeOverdrive = false;
        volumeStep = 5;
      };

      brightness = {
        backlightDeviceMappings = [ ];
        brightnessStep = 5;
        enableDdcSupport = true;
        enforceMinimum = true;
      };

      calendar = {
        cards = [
          { enabled = true; id = "calendar-header-card"; }
          { enabled = true; id = "calendar-month-card"; }
          { enabled = true; id = "weather-card"; }
        ];
      };

      colorSchemes = {
        darkMode = true;
        generationMethod = "tonal-spot";
        manualSunrise = "06:30";
        manualSunset = "18:30";
        monitorForColors = "";
        predefinedScheme = "Catppuccin";
        schedulingMode = "off";
        syncGsettings = true;
        useWallpaperColors = true;
      };

      controlCenter = {
        cards = [
          { enabled = true; id = "profile-card"; }
          { enabled = true; id = "shortcuts-card"; }
          { enabled = true; id = "audio-card"; }
          { enabled = true; id = "brightness-card"; }
          { enabled = true; id = "weather-card"; }
          { enabled = true; id = "media-sysmon-card"; }
        ];
        diskPath = "/";
        position = "close_to_bar_button";
        shortcuts = {
          left = [
            { id = "Network"; }
            { id = "Bluetooth"; }
            { id = "WallpaperSelector"; }
            { id = "NoctaliaPerformance"; }
          ];
          right = [
            { id = "Notifications"; }
            { id = "PowerProfile"; }
            { id = "KeepAwake"; }
            { id = "NightLight"; }
          ];
        };
      };

      desktopWidgets = {
        enabled = false;
        gridSnap = false;
        gridSnapScale = false;
        monitorWidgets = [ ];
        overviewEnabled = true;
      };

      dock = {
        animationSpeed = 1;
        backgroundOpacity = 1;
        colorizeIcons = false;
        deadOpacity = 0.6;
        displayMode = "auto_hide";
        dockType = "floating";
        enabled = true;
        floatingRatio = 0.25;
        groupApps = true;
        groupClickAction = "cycle";
        groupContextMenuMode = "extended";
        groupIndicatorStyle = "dots";
        inactiveIndicators = true;
        indicatorColor = "primary";
        indicatorOpacity = 0.6;
        indicatorThickness = 3;
        launcherIcon = "";
        launcherIconColor = "none";
        launcherPosition = "start";
        launcherUseDistroLogo = true;
        monitors = [ ];
        onlySameOutput = false;
        pinnedApps = [ ];
        pinnedStatic = true;
        position = "bottom";
        showDockIndicator = false;
        showLauncherIcon = true;
        sitOnFrame = false;
        size = 1.49;
      };

      general = {
        allowPanelsOnScreenWithoutBar = false;
        allowPasswordWithFprintd = true;
        animationDisabled = false;
        animationSpeed = 1;
        autoStartAuth = false;
        avatarImage = "/home/james/.face";
        boxRadiusRatio = 1;
        clockFormat = "hh\\nmmdd.MM.yyyy ";
        clockStyle = "analog";
        compactLockScreen = false;
        dimmerOpacity = 0.3;
        enableBlurBehind = true;
        enableLockScreenCountdown = true;
        enableLockScreenMediaControls = false;
        enableShadows = false;
        forceBlackScreenCorners = true;
        iRadiusRatio = 0.7000000000000001;
        keybinds = {
          keyDown = [ "Down" "Ctrl+N" ];
          keyEnter = [ "Return" "Enter" ];
          keyEscape = [ "Esc" ];
          keyLeft = [ "Left" ];
          keyRemove = [ "Del" ];
          keyRight = [ "Right" ];
          keyUp = [ "Up" "Ctrl+P" ];
        };
        language = "";
        lockOnSuspend = true;
        lockScreenAnimations = true;
        lockScreenBlur = 0.56;
        lockScreenCountdownDuration = 10000;
        lockScreenMonitors = [ ];
        lockScreenTint = 0.27;
        passwordChars = true;
        radiusRatio = 0.59;
        reverseScroll = false;
        scaleRatio = 1;
        screenRadiusRatio = 0.5700000000000001;
        shadowDirection = "bottom_right";
        shadowOffsetX = 2;
        shadowOffsetY = 3;
        showChangelogOnStartup = true;
        showHibernateOnLockScreen = false;
        showScreenCorners = true;
        showSessionButtonsOnLockScreen = true;
        telemetryEnabled = false;
      };

      hooks = {
        colorGeneration = "";
        darkModeChange = "";
        enabled = false;
        performanceModeDisabled = "";
        performanceModeEnabled = "";
        screenLock = "";
        screenUnlock = "";
        session = "";
        startup = "";
        wallpaperChange = "";
      };

      idle = {
        customCommands = "[]";
        enabled = true;
        fadeDuration = 5;
        lockCommand = "";
        lockTimeout = 300;
        resumeLockCommand = "";
        resumeScreenOffCommand = "";
        resumeSuspendCommand = "";
        screenOffCommand = "";
        screenOffTimeout = 305;
        suspendCommand = "";
        suspendTimeout = 1800;
      };

      location = {
        analogClockInCalendar = true;
        firstDayOfWeek = 1;
        hideWeatherCityName = false;
        hideWeatherTimezone = false;
        name = "Derby, UK";
        showCalendarEvents = true;
        showCalendarWeather = true;
        showWeekNumberInCalendar = false;
        use12hourFormat = false;
        useFahrenheit = false;
        weatherEnabled = true;
        weatherShowEffects = true;
      };

      network = {
        airplaneModeEnabled = false;
        bluetoothAutoConnect = true;
        bluetoothDetailsViewMode = "grid";
        bluetoothHideUnnamedDevices = false;
        bluetoothRssiPollIntervalMs = 60000;
        bluetoothRssiPollingEnabled = false;
        disableDiscoverability = false;
        networkPanelView = "wifi";
        wifiDetailsViewMode = "grid";
      };

      nightLight = {
        autoSchedule = true;
        dayTemp = "6500";
        enabled = false;
        forced = false;
        manualSunrise = "06:30";
        manualSunset = "18:30";
        nightTemp = "4000";
      };

      noctaliaPerformance = {
        disableDesktopWidgets = true;
        disableWallpaper = true;
      };

      plugins = {
        autoUpdate = true;
        notifyUpdates = true;
      };

      sessionMenu = {
        countdownDuration = 10000;
        enableCountdown = true;
        largeButtonsLayout = "single-row";
        largeButtonsStyle = true;
        position = "center";
        powerOptions = [
          { action = "lock"; command = ""; countdownEnabled = true; enabled = true; keybind = "1"; }
          { action = "suspend"; command = ""; countdownEnabled = true; enabled = true; keybind = "2"; }
          { action = "hibernate"; command = ""; countdownEnabled = true; enabled = true; keybind = "3"; }
          { action = "reboot"; command = ""; countdownEnabled = true; enabled = true; keybind = "4"; }
          { action = "logout"; command = ""; countdownEnabled = true; enabled = true; keybind = "5"; }
          { action = "shutdown"; command = ""; countdownEnabled = true; enabled = true; keybind = "6"; }
          { action = "rebootToUefi"; command = ""; countdownEnabled = true; enabled = true; keybind = "7"; }
          { action = "userspaceReboot"; command = ""; countdownEnabled = true; enabled = false; keybind = ""; }
        ];
        showHeader = true;
        showKeybinds = true;
      };

      systemMonitor = {
        batteryCriticalThreshold = 5;
        batteryWarningThreshold = 20;
        cpuCriticalThreshold = 90;
        cpuWarningThreshold = 80;
        criticalColor = "";
        diskAvailCriticalThreshold = 10;
        diskAvailWarningThreshold = 20;
        diskCriticalThreshold = 90;
        diskWarningThreshold = 80;
        enableDgpuMonitoring = false;
        externalMonitor = "resources || missioncenter || jdsystemmonitor || corestats || system-monitoring-center || gnome-system-monitor || plasma-systemmonitor || mate-system-monitor || ukui-system-monitor || deepin-system-monitor || pantheon-system-monitor";
        gpuCriticalThreshold = 90;
        gpuWarningThreshold = 80;
        memCriticalThreshold = 90;
        memWarningThreshold = 80;
        swapCriticalThreshold = 90;
        swapWarningThreshold = 80;
        tempCriticalThreshold = 90;
        tempWarningThreshold = 80;
        useCustomColors = false;
        warningColor = "";
      };

      templates = {
        activeTemplates = [ ];
        enableUserTheming = false;
      };

      ui = {
        boxBorderEnabled = true;
        fontDefault = "Sans Serif";
        fontDefaultScale = 1;
        fontFixed = "monospace";
        fontFixedScale = 1;
        panelBackgroundOpacity = 0.9;
        panelsAttachedToBar = true;
        scrollbarAlwaysVisible = false;
        settingsPanelMode = "window";
        settingsPanelSideBarCardStyle = false;
        tooltipsEnabled = true;
        translucentWidgets = true;
      };

      wallpaper = {
        automationEnabled = false;
        directory = "/home/james/Pictures/Wallpapers";
        enableMultiMonitorDirectories = false;
        enabled = true;
        favorites = [ ];
        fillColor = "#000000";
        fillMode = "crop";
        hideWallpaperFilenames = false;
        monitorDirectories = [ ];
        overviewBlur = 0.4;
        overviewEnabled = false;
        overviewTint = 0.6;
        panelPosition = "follow_bar";
        randomIntervalSec = 300;
        setWallpaperOnAllMonitors = true;
        showHiddenFiles = false;
        skipStartupTransition = false;
        solidColor = "#1a1a2e";
        sortOrder = "name";
        transitionDuration = 1500;
        transitionEdgeSmoothness = 0.05;
        transitionType = [ "fade" "disc" "stripes" "wipe" "pixelate" "honeycomb" ];
        useOriginalImages = false;
        useSolidColor = false;
        useWallhaven = false;
        viewMode = "single";
        wallhavenApiKey = "";
        wallhavenCategories = "111";
        wallhavenOrder = "desc";
        wallhavenPurity = "100";
        wallhavenQuery = "";
        wallhavenRatios = "";
        wallhavenResolutionHeight = "";
        wallhavenResolutionMode = "atleast";
        wallhavenResolutionWidth = "";
        wallhavenSorting = "relevance";
        wallpaperChangeMode = "random";
      };

      bar = {
        showCapsule = true;
        autoHideDelay = 500;
        autoShowDelay = 150;
        backgroundOpacity = 0;
        barType = "simple";
        capsuleColorKey = "none";
        capsuleOpacity = 0.9;
        contentPadding = 2;
        density = "compact";
        displayMode = "always_visible";
        enableExclusionZoneInset = true;
        fontScale = 1;
        frameRadius = 12;
        frameThickness = 8;
        hideOnOverview = true;
        marginHorizontal = 4;
        marginVertical = 4;
        middleClickAction = "settings";
        middleClickCommand = "";
        middleClickFollowMouse = false;
        monitors = [ ];
        mouseWheelAction = "workspace";
        mouseWheelWrap = true;
        outerCorners = true;
        position = "bottom";
        reverseScroll = false;
        rightClickAction = "controlCenter";
        rightClickCommand = "";
        rightClickFollowMouse = true;
        screenOverrides = [ ];
        showOnWorkspaceSwitch = true;
        showOutline = false;
        useSeparateOpacity = true;
        widgetSpacing = 6;
        widgets = {
          left = [
            {
              id = "Launcher";
              colorizeSystemIcon = "none";
              customIconPath = "";
              enableColorization = false;
              icon = "rocket";
              iconColor = "none";
              useDistroLogo = true;
            }
            {
              id = "Workspace";
              hideUnoccupied = true;
              labelMode = "none";
              characterCount = 2;
              colorizeIcons = false;
              emptyColor = "secondary";
              enableScrollWheel = true;
              focusedColor = "primary";
              followFocusedScreen = false;
              fontWeight = "bold";
              groupedBorderOpacity = 1;
              iconScale = 0.8;
              occupiedColor = "secondary";
              pillSize = 0.6;
              showApplications = true;
              showApplicationsHover = false;
              showBadge = false;
              showLabelsOnlyWhenOccupied = true;
              unfocusedIconsOpacity = 1;
            }
          ];
          center = [
            {
              id = "Clock";
              formatHorizontal = "dddd d MMMM HH:mm:ss";
              clockColor = "none";
              customFont = "";
              formatVertical = "HH mm - dd MM";
              tooltipFormat = "HH:mm ddd, MMM dd";
              useCustomFont = false;
            }
            {
              id = "plugin:screen-toolkit";
            }
          ];
          right = [
            {
              id = "Tray";
              blacklist = [ ];
              chevronColor = "none";
              colorizeIcons = false;
              drawerEnabled = true;
              hidePassive = false;
              pinned = [ "1Password" ];
            }
            {
              id = "plugin:privacy-indicator";
              defaultSettings = {
                activeColor = "primary";
                enableToast = true;
                hideInactive = false;
                iconSpacing = 4;
                inactiveColor = "none";
                micFilterRegex = "";
                removeMargins = false;
              };
            }
            {
              id = "SystemMonitor";
              compactMode = false;
              diskPath = "/";
              iconColor = "none";
              showCpuCores = true;
              showCpuFreq = false;
              showCpuTemp = true;
              showCpuUsage = true;
              showDiskAvailable = false;
              showDiskUsage = false;
              showDiskUsageAsPercent = false;
              showGpuTemp = false;
              showLoadAverage = false;
              showMemoryAsPercent = false;
              showMemoryUsage = true;
              showNetworkStats = false;
              showSwapUsage = false;
              textColor = "none";
              useMonospaceFont = true;
              usePadding = false;
            }
            {
              id = "Volume";
              displayMode = "onhover";
              iconColor = "none";
              middleClickCommand = "pwvucontrol || pavucontrol";
              textColor = "none";
            }
            {
              id = "Battery";
              deviceNativePath = "__default__";
              displayMode = "graphic";
              hideIfIdle = false;
              hideIfNotDetected = true;
              showNoctaliaPerformance = false;
              showPowerProfiles = true;
            }
            {
              id = "ControlCenter";
              colorizeDistroLogo = false;
              colorizeSystemIcon = "none";
              customIconPath = "";
              enableColorization = true;
              icon = "adjustments-alt";
              useDistroLogo = false;
            }
          ];
        };
      };

      notifications = {
        backgroundOpacity = 0.78;
        clearDismissed = true;
        criticalUrgencyDuration = 15;
        density = "default";
        enableBatteryToast = true;
        enableKeyboardLayoutToast = true;
        enableMarkdown = true;
        enableMediaToast = false;
        enabled = true;
        location = "bottom_right";
        lowUrgencyDuration = 3;
        monitors = [ ];
        normalUrgencyDuration = 8;
        overlayLayer = true;
        respectExpireTimeout = true;
        saveToHistory = {
          critical = true;
          low = true;
          normal = true;
        };
        sounds = {
          criticalSoundFile = "";
          enabled = true;
          excludedApps = "discord,firefox,chrome,chromium,edge,slack";
          lowSoundFile = "";
          normalSoundFile = "";
          separateSounds = true;
          volume = 0.3;
        };
      };

      osd = {
        autoHideMs = 2000;
        backgroundOpacity = 0.9;
        enabled = true;
        enabledTypes = [ 0 1 2 3 ];
        location = "bottom";
        monitors = [ ];
        overlayLayer = true;
      };
    };

    plugins = {
        sources = [
          {
            enabled = true;
            name = "Noctalia Plugins";
            url = "https://github.com/noctalia-dev/noctalia-plugins";
          }
        ];
        states = {
          polkit-agent = {
            enabled = true;
            sourceUrl = "https://github.com/noctalia-dev/noctalia-plugins";
          };
          privacy-indicator = {
            enabled = true;
            sourceUrl = "https://github.com/noctalia-dev/noctalia-plugins";
          };
          screen-toolkit = {
            enabled = true;
            sourceUrl = "https://github.com/noctalia-dev/noctalia-plugins";
          };
        };
        version = 2;
    };
  };

  # Wallpaper via Noctalia
  home.file.".cache/noctalia/wallpapers.json" = {
    text = builtins.toJSON {
      defaultWallpaper = "${pkgs.nixos-artwork.wallpapers.moonscape}/share/backgrounds/nixos/nix-wallpaper-moonscape.png";
      wallpapers = { };
    };
  };

  programs.niri.settings = {
    debug.honor-xdg-activation-with-invalid-serial = true;
    prefer-no-csd = true;
    spawn-at-startup = [
      { command = [ "noctalia-shell" ]; }
    ];
    switch-events = with config.lib.niri.actions; {
      lid-close.action = spawn "noctalia-shell" "ipc" "call" "lockScreen" "lock";
    };
    binds = with config.lib.niri.actions; {
      "Mod+Escape".action = spawn "noctalia-shell" "ipc" "call" "lockScreen" "lock";
      "Mod+Shift+Escape".action = quit;
      "Mod+W".action = close-window;

      "Mod+F".action = toggle-window-floating;
      "Mod+R".action = switch-preset-column-width;
      "Mod+T".action = toggle-column-tabbed-display;

      "Mod+K".action = focus-window-up;
      "Mod+J".action = focus-window-down;
      "Mod+H".action = focus-column-left;
      "Mod+L".action = focus-column-right;
      "Mod+P".action = focus-workspace-up;
      "Mod+N".action = focus-workspace-down;

      "Mod+1".action = focus-window-in-column 1;
      "Mod+2".action = focus-window-in-column 2;
      "Mod+3".action = focus-window-in-column 3;
      "Mod+4".action = focus-window-in-column 4;
      "Mod+5".action = focus-window-in-column 5;
      "Mod+6".action = focus-window-in-column 6;
      "Mod+7".action = focus-window-in-column 7;
      "Mod+8".action = focus-window-in-column 8;
      "Mod+9".action = focus-window-in-column 9;

      "Mod+Alt+K".action = move-window-up;
      "Mod+Alt+J".action = move-window-down;
      "Mod+Alt+H".action = move-column-left;
      "Mod+Alt+L".action = move-column-right;
      "Mod+Alt+P".action = move-window-to-workspace-up;
      "Mod+Alt+N".action = move-window-to-workspace-down;

      "Mod+Shift+H".action = consume-or-expel-window-left;
      "Mod+Shift+L".action = consume-or-expel-window-right;

      "Mod+M".action = focus-monitor-next;
      "Mod+Alt+M".action = move-column-to-monitor-next;

      "Mod+Space".action = spawn "noctalia-shell" "ipc" "call" "launcher" "toggle";
      "Mod+Return".action = spawn "ghostty";
      "Mod+B".action = spawn "firefox";

      # Function Keys
      "XF86AudioRaiseVolume".action = spawn "noctalia-shell" "ipc" "call" "volume" "increase";
      "XF86AudioLowerVolume".action = spawn "noctalia-shell" "ipc" "call" "volume" "decrease";
      "XF86AudioMute".action = spawn "noctalia-shell" "ipc" "call" "volume" "muteOutput";
      "XF86MonBrightnessUp".action = spawn "noctalia-shell" "ipc" "call" "brightness" "increase";
      "XF86MonBrightnessDown".action = spawn "noctalia-shell" "ipc" "call" "brightness" "decrease";
      "XF86AudioPlay".action = spawn "noctalia-shell" "ipc" "call" "media" "playPause";
      "XF86AudioPrev".action = spawn "noctalia-shell" "ipc" "call" "media" "previous";
      "XF86AudioNext".action = spawn "noctalia-shell" "ipc" "call" "media" "next";

      "Print".action.screenshot = [ ];
    };
    layout = {
      gaps = 8;
      # struts = {
      #   left = 8;
      #   right = 8;
      # };
      border.width = 2;
      default-column-width.proportion = 0.66667;
      preset-column-widths = [
        { proportion = 0.33333; }
        { proportion = 0.5; }
        { proportion = 0.66667; }
        { proportion = 1.0; }
      ];
      background-color = "transparent";
      focus-ring = {
        active.color = "#adc7ff";
        inactive.color = "#121316";
        urgent.color = "#ffb4ab";
      };
      border = {
        active.color = "#adc7ff";
        inactive.color = "#121316";
        urgent.color = "#ffb4ab";
      };
      shadow.color = "#00000070";
      tab-indicator = {
        active.color = "#adc7ff";
        inactive.color = "#0c448e";
        urgent.color = "#ffb4ab";
      };
    };
    overview.workspace-shadow.enable = false;
    window-rules = [
      {
        matches = [
          { title = "update-system"; }
        ];
        default-column-width = {
          proportion = 0.7;
        };
        open-floating = true;
      }
      {
        geometry-corner-radius = {
          bottom-left = 8.0;
          bottom-right = 8.0;
          top-left = 8.0;
          top-right = 8.0;
        };
        clip-to-geometry = true;
      }
    ];
    layer-rules = [
      {
        matches = [
          { namespace = "^noctalia-overview*"; }
        ];
        place-within-backdrop = true;
      }
    ];
    input = {
      touchpad = {
        click-method = "clickfinger";
      };
    };
    cursor = {
      # See top of this file for the default cursor
      theme = "default";
      size = 24;
    };
    outputs =
      let
        after = output: output.position.x + builtins.floor (output.mode.width / output.scale);

        fw13 = {
          scale = 1.5;
          mode = {
            width = 2256;
            height = 1504;
          };
          position = {
            x = 0;
            y = 0;
          };
        };
        thinkpad = {
          scale = 1.0;
          mode = {
            width = 1920;
            height = 1200;
          };
          position = {
            x = 0;
            y = 0;
          };
          variable-refresh-rate = true;
        };

        builtin = thinkpad;

        samsung = {
          scale = 2.0;
          mode = {
            width = 5120;
            height = 2889;
          };
          position = {
            x = after builtin;
            y = 0;
          };
        };
        acer = {
          scale = 1.0;
          mode = {
            width = 1920;
            height = 1080;
          };
          position = {
            x = after samsung;
            y = 0;
          };
        };
        tx-ultrawide = {
          scale = 1.0;
          mode = {
            width = 3440;
            height = 1440;
            refresh = 59.973;
          };
          position = {
            x = 1920;
            y = builtins.floor (thinkpad.mode.height / 3.0) - 1440;
          };
          # variable-refresh-rate = true;
        };
        dell-p2414h = {
          scale = 1.0;
          mode = {
            width = 1920;
            height = 1080;
            refresh = 60.0;
          };
          position = {
            x = tx-ultrawide.position.x + builtins.floor (tx-ultrawide.mode.width / 2.0);
            y = tx-ultrawide.position.y - 1080;
          };
        };
      in
      {
        "Acer Technologies SA240Y T92EE0012410" = acer;
        "Lenovo Group Limited MNG007QT1-2 Unknown" = thinkpad;
        "Iiyama North America PL3494WQ 1214142721111" = tx-ultrawide;
        "Dell Inc. DELL P2414H 4YN5344O06GL" = dell-p2414h;
        "Samsung Electric Company S27C900P H1AK500000" = samsung;
      };
  };
}
