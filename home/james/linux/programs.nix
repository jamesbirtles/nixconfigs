{ firefox-gnome-theme, pkgs, lib, vscode-extensions, ... }:
let
  codeExtensions = with vscode-extensions; [
    svelte.svelte-vscode
    asvetliakov.vscode-neovim
    dbaeumer.vscode-eslint
    esbenp.prettier-vscode
    usernamehw.errorlens
    bbenoist.nix
    joshmu.periscope
    tompollak.lazygit-vscode
    vscode-icons-team.vscode-icons
    bradlc.vscode-tailwindcss
  ];

  codeSettings = {
    "editor.fontSize" = 16;
    "editor.fontFamily" = "'BerkeleyMono Nerd Font', 'Droid Sans Mono', 'monospace', monospace";
    "editor.fontLigatures" = false;
    "editor.defaultFormatter" = "esbenp.prettier-vscode";
    "editor.formatOnSave" = true;
    "editor.lineNumbers" = "relative";
    "workbench.iconTheme" = "vscode-icons";
    "workbench.activityBar.orientation" = "vertical";
    "workbench.colorCustomizations" = {
      "editor.lineHighlightBackground" = "#262626";
    };
    "window.experimentalControlOverlay" = false;
    "files.trimTrailingWhitespace" = true;

    "extensions.ignoreRecommendations" = true;
    "extensions.experimental.affinity" = {
      "asvetliakov.vscode-neovim" = 1;
    };

    "problems.autoReveal" = false;
    "problems.defaultViewMode" = "table";
    "problems.sortOrder" = "position";

    "errorLens.gutterIconsEnabled" = true;
    "errorLens.gutterIconSet" = "defaultOutline";
    "errorLens.statusBarColorsEnabled" = true;
    "errorLens.statusBarMessageEnabled" = true;

    "svelte.enable-ts-plugin" = true;
    "svelte.plugin.svelte.defaultScriptLanguage" = "ts";
    "svelte.plugin.html.tagComplete.enable" = false;

    "typescript.format.enable" = false;
    "typescript.preferences.importModuleSpecifierEnding" = "js";
    "typescript.preferences.preferTypeOnlyAutoImports" = true;
    "typescript.preferGoToSourceDefinition" = true;
    "typescript.suggest.completeFunctionCalls" = true;
    "typescript.suggest.jsdoc.generateReturns" = false;
    "typescript.surveys.enabled" = false;
    # This sounds like it might be intensive
    "typescript.tsserver.experimental.enableProjectDiagnostics" = true;
    "typescript.tsserver.nodePath" = "${pkgs.nodejs_20}/bin/node";
    "typescript.tsserver.maxTsServerMemory" = 1024 * 8;

    "eslint.run" = "onSave";
    "vscode-neovim.neovimInitVimPaths.linux" = ./neovim-vscode.lua;
    "lazygit-vscode.lazygitPath" = "${pkgs.lazygit}/bin/lazygit";
    "vscode-neovim.neovimExecutablePaths.linux" = "${pkgs.neovim}/bin/nvim";
    "vsicons.dontShowNewVersionMessage" = true;
  };

  codeKeybinds = [
    { key = "space"; command = "vscode-neovim.send"; args = "<space>"; when = "filesExplorerFocus"; }
    { key = "B"; command = "vscode-neovim.send"; args = "b"; when = "filesExplorerFocus"; }
  ];
in
{

  programs.code-cursor = {
    enable = true;
    extensions = codeExtensions;
    userSettings = codeSettings;
    keybindings = codeKeybinds;
    mutableExtensionsDir = false;
  };
  programs.vscode = {
    enable = true;
    extensions = with vscode-extensions; [
      ms-vsliveshare.vsliveshare
      gustavoprietodepaula.anysphere-modern
    ] ++ codeExtensions;
    userSettings = lib.mkMerge [
      codeSettings
      {
        # Match cursor defaults
        "workbench.colorTheme" = "Anysphere Modern";
        "window.titleBarStyle" = "custom";
      }
    ];
    keybindings = codeKeybinds;
    mutableExtensionsDir = false;
  };

  programs.obs-studio = {
    enable = true;
  };

  home.file.".mozilla/firefox/default/chrome/firefox-gnome-theme".source = firefox-gnome-theme;

  programs.firefox.enable = true;
  programs.firefox.profiles.default = {
    id = 0;
    name = "default";
    isDefault = true;
    userChrome = ''
      @import "firefox-gnome-theme/userChrome.css";
    '';
    userContent = ''
      @import "firefox-gnome-theme/userContent.css";
    '';
    settings = {
      ## Firefox gnome theme ## - https://github.com/rafaelmardojai/firefox-gnome-theme/blob/7cba78f5216403c4d2babb278ff9cc58bcb3ea66/configuration/user.js
      # (copied into here because home-manager already writes to user.js)
      "toolkit.legacyUserProfileCustomizations.stylesheets" = true; # Enable customChrome.cs
      "browser.uidensity" = 0; # Set UI density to normal
      "svg.context-properties.content.enabled" = true; # Enable SVG context-propertes
      "browser.theme.dark-private-windows" = false; # Disable private window dark theme
      "widget.gtk.rounded-bottom-corners.enabled" = true; # Enable rounded bottom window corners
      "gnomeTheme.hideSingleTab" = true;
    };
  };

  programs.rbw = {
    enable = true;
    settings.email = "jameshbirtles@gmail.com";
    settings.pinentry = pkgs.pinentry-gnome3;
  };
  programs.aerc = {
    enable = true;
    extraConfig.general.unsafe-accounts-conf = true;
  };
}

