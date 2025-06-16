{ firefox-gnome-theme, pkgs, lib, vscode-extensions, ... }:
let
  codeExtensions = with vscode-extensions; [
    svelte.svelte-vscode
    # asvetliakov.vscode-neovim
    vscodevim.vim
    # dbaeumer.vscode-eslint
    esbenp.prettier-vscode
    usernamehw.errorlens
    bbenoist.nix
    joshmu.periscope
    bradlc.vscode-tailwindcss
    tamasfe.even-better-toml
    connor4312.esbuild-problem-matchers
    ms-vscode.extension-test-runner
    # tompollak.lazygit-vscode
    # vscode-icons-team.vscode-icons
    effectful-tech.effect-vscode
  ];

  codeSettings = {
    "editor.fontSize" = 16;
    "editor.fontFamily" = "'BerkeleyMono Nerd Font', 'Droid Sans Mono', 'monospace', monospace";
    "editor.fontLigatures" = false;
    "editor.defaultFormatter" = "esbenp.prettier-vscode";
    "editor.formatOnSave" = true;
    "editor.lineNumbers" = "relative";
    # Effectively turns off middle click paste
    "editor.selectionClipboard" = false;
    "workbench.iconTheme" = "vscode-icons";
    "workbench.activityBar.orientation" = "vertical";
    "workbench.colorCustomizations" = {
      "editor.lineHighlightBackground" = "#262626";
    };
    "files.trimTrailingWhitespace" = true;

    "extensions.ignoreRecommendations" = true;
    "extensions.experimental.affinity" = {
      # "asvetliakov.vscode-neovim" = 1;
      "vscodevim.vim" = 1;
    };

    "problems.autoReveal" = false;
    "problems.defaultViewMode" = "table";
    "problems.sortOrder" = "position";

    "errorLens.gutterIconsEnabled" = false;
    "errorLens.gutterIconSet" = "defaultOutline";
    "errorLens.statusBarColorsEnabled" = false;
    "errorLens.statusBarMessageEnabled" = false;

    "svelte.enable-ts-plugin" = true;
    "svelte.plugin.svelte.defaultScriptLanguage" = "ts";
    "svelte.plugin.html.tagComplete.enable" = false;
    "svelte.language-server.runtime" = "${pkgs.nodejs_22}/bin/node";
    "svelte.language-server.runtime-args" = [ "--max-old-space-size=16184" ];

    "typescript.format.enable" = false;
    "typescript.preferences.importModuleSpecifierEnding" = "minimal";
    "typescript.preferences.preferTypeOnlyAutoImports" = true;
    "typescript.preferGoToSourceDefinition" = true;
    "typescript.suggest.completeFunctionCalls" = true;
    "typescript.suggest.jsdoc.generateReturns" = false;
    "typescript.surveys.enabled" = false;
    # This sounds like it might be intensive
    "typescript.tsserver.experimental.enableProjectDiagnostics" = false;
    "typescript.tsserver.nodePath" = "${pkgs.nodejs_22}/bin/node";
    "typescript.tsserver.maxTsServerMemory" = 1024 * 16;
    "typescript.disableAutomaticTypeAcquisition" = true;

    "eslint.run" = "onSave";
    # "vscode-neovim.neovimInitVimPaths.linux" = ./neovim-vscode.lua;
    # "vscode-neovim.neovimExecutablePaths.linux" = "${pkgs.neovim}/bin/nvim";
    "lazygit-vscode.lazygitPath" = "${pkgs.lazygit}/bin/lazygit";
    "vsicons.dontShowNewVersionMessage" = true;
    "window.titleBarStyle" = "custom";
    "window.experimentalControlOverlay" = true;

    "vim.useSystemClipboard" = true;
    "vim.highlightedyank.enable" = true;
    "vim.leader" = " ";
    "vim.camelCaseMotion.enable" = true;
    "vim.normalModeKeyBindings" = [
      { "before" = ["<leader>" "b"]; "commands" = ["workbench.action.toggleSidebarVisibility"]; }
      { "before" = ["<leader>" "t"]; "commands" = ["workbench.action.createTerminalEditor"]; }
      { "before" = ["<leader>" "p" "f"]; "commands" = ["workbench.action.quickOpen"]; }
      { "before" = ["<leader>" "p" "s"]; "commands" = ["periscope.search"]; }
      { "before" = ["<leader>" "p" "r"]; "commands" = ["workbench.action.replaceInFiles"]; }
      { "before" = ["<leader>" "l" "g"]; "commands" = ["lazygit-vscode.toggle"]; }
      { "before" = ["<leader>" "w"]; "commands" = ["workbench.action.files.save"]; }
      { "before" = ["<leader>" "W"]; "commands" = ["workbench.action.files.saveAll"]; }
      { "before" = ["g" "a"]; "commands" = ["editor.action.quickFix"]; }
      { "before" = ["g" "n"]; "commands" = ["editor.action.marker.next"]; }
      { "before" = ["g" "p"]; "commands" = ["editor.action.marker.prev"]; }
      { "before" = ["g" "r"]; "commands" = ["editor.action.rename"]; }
    ];
  };

  codeKeybinds = [
    # { key = "space"; command = "vscode-neovim.send"; args = "<space>"; when = "filesExplorerFocus && !inputFocus"; }
    # { key = "B"; command = "vscode-neovim.send"; args = "b"; when = "filesExplorerFocus && !inputFocus"; }
    { key = "shift+k"; command = "editor.action.showHover"; "when" = "editorTextFocus && vim.mode == 'Normal'"; }
    { key = "ctrl+u"; command = "editor.action.pageUpHover"; "when" = "editorHoverFocused"; }
    { key = "ctrl+d"; command = "editor.action.pageDownHover"; "when" = "editorHoverFocused"; }
    { key = "ctrl+n"; command = "selectNextCodeAction"; "when" = "codeActionMenuVisible"; }
    { key = "ctrl+p"; command = "selectPrevCodeAction"; "when" = "codeActionMenuVisible"; }
    { key = "ctrl+n"; command = "quickInput.next"; "when" = "inQuickInput && quickInputType == 'quickPick'"; }
    { key = "ctrl+p"; command = "quickInput.previous"; "when" = "inQuickInput && quickInputType == 'quickPick'"; }
  ];
in
{
  home.packages = with pkgs; [
    nodejs_22
    corepack_22
    gnome-obfuscate
  ];

  programs.code-cursor = {
    enable = true;
    extensions = codeExtensions;
    userSettings = codeSettings;
    keybindings = codeKeybinds;
    mutableExtensionsDir = false;
  };
  # programs.vscode = {
  #   enable = true;
  #   profiles.default = {
  #     extensions = with vscode-extensions; [
  #       ms-vsliveshare.vsliveshare
  #       gustavoprietodepaula.anysphere-modern
  #     ] ++ codeExtensions;
  #     userSettings = lib.mkMerge [
  #       codeSettings
  #       {
  #         # Match cursor defaults
  #         "workbench.colorTheme" = "Anysphere Modern";
  #       }
  #     ];
  #     keybindings = codeKeybinds;
  #   };
  #   mutableExtensionsDir = false;
  # };

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
  # programs.aerc = {
  #   enable = true;
  #   extraConfig.general.unsafe-accounts-conf = true;
  # };

  programs.ssh = {
    enable = true;
    extraConfig = ''
      Host *
          IdentityAgent ~/.1password/agent.sock
    '';
  };

  programs.ghostty = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      keybind = [
        "alt+one=unbind"
        "alt+two=unbind"
        "alt+three=unbind"
        "alt+four=unbind"
        "alt+five=unbind"
        "alt+six=unbind"
        "alt+seven=unbind"
        "alt+eight=unbind"
        "alt+nine=unbind"
        "shift+enter=text:\\n"
      ];
      font-family = "BerkeleyMono Nerd Font";
      theme = "ayu";
    };
  };
}

