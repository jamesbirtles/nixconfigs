{
  config,
  lib,
  pkgs,
  vscode-extensions,
  ...
}:
let
  cfg = config.features.development.cursor;

  codeExtensions = with vscode-extensions; [
    svelte.svelte-vscode
    vscodevim.vim
    esbenp.prettier-vscode
    usernamehw.errorlens
    bbenoist.nix
    joshmu.periscope
    bradlc.vscode-tailwindcss
    tamasfe.even-better-toml
    connor4312.esbuild-problem-matchers
    ms-vscode.extension-test-runner
    effectful-tech.effect-vscode
  ];

  codeSettings = {
    "editor.fontSize" = 16;
    "editor.fontFamily" = "'BerkeleyMono Nerd Font', 'Droid Sans Mono', 'monospace', monospace";
    "editor.fontLigatures" = false;
    "editor.defaultFormatter" = "esbenp.prettier-vscode";
    "editor.formatOnSave" = true;
    "editor.lineNumbers" = "relative";
    "editor.selectionClipboard" = false;
    "workbench.iconTheme" = "vscode-icons";
    "workbench.activityBar.orientation" = "vertical";
    "workbench.colorCustomizations" = {
      "editor.lineHighlightBackground" = "#262626";
    };
    "files.trimTrailingWhitespace" = true;

    "extensions.ignoreRecommendations" = true;
    "extensions.experimental.affinity" = {
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
    "typescript.tsserver.experimental.enableProjectDiagnostics" = false;
    "typescript.tsserver.nodePath" = "${pkgs.nodejs_22}/bin/node";
    "typescript.tsserver.maxTsServerMemory" = 1024 * 16;
    "typescript.disableAutomaticTypeAcquisition" = true;

    "eslint.run" = "onSave";
    "lazygit-vscode.lazygitPath" = "${pkgs.lazygit}/bin/lazygit";
    "vsicons.dontShowNewVersionMessage" = true;
    "window.titleBarStyle" = "custom";
    "window.experimentalControlOverlay" = true;

    "vim.useSystemClipboard" = true;
    "vim.highlightedyank.enable" = true;
    "vim.leader" = " ";
    "vim.camelCaseMotion.enable" = true;
    "vim.normalModeKeyBindings" = [
      {
        "before" = [
          "<leader>"
          "b"
        ];
        "commands" = [ "workbench.action.toggleSidebarVisibility" ];
      }
      {
        "before" = [
          "<leader>"
          "t"
        ];
        "commands" = [ "workbench.action.createTerminalEditor" ];
      }
      {
        "before" = [
          "<leader>"
          "p"
          "f"
        ];
        "commands" = [ "workbench.action.quickOpen" ];
      }
      {
        "before" = [
          "<leader>"
          "p"
          "s"
        ];
        "commands" = [ "periscope.search" ];
      }
      {
        "before" = [
          "<leader>"
          "p"
          "r"
        ];
        "commands" = [ "workbench.action.replaceInFiles" ];
      }
      {
        "before" = [
          "<leader>"
          "l"
          "g"
        ];
        "commands" = [ "lazygit-vscode.toggle" ];
      }
      {
        "before" = [
          "<leader>"
          "w"
        ];
        "commands" = [ "workbench.action.files.save" ];
      }
      {
        "before" = [
          "<leader>"
          "W"
        ];
        "commands" = [ "workbench.action.files.saveAll" ];
      }
      {
        "before" = [
          "g"
          "a"
        ];
        "commands" = [ "editor.action.quickFix" ];
      }
      {
        "before" = [
          "g"
          "n"
        ];
        "commands" = [ "editor.action.marker.next" ];
      }
      {
        "before" = [
          "g"
          "p"
        ];
        "commands" = [ "editor.action.marker.prev" ];
      }
      {
        "before" = [
          "g"
          "r"
        ];
        "commands" = [ "editor.action.rename" ];
      }
    ];
  };

  codeKeybinds = [
    {
      key = "shift+k";
      command = "editor.action.showHover";
      "when" = "editorTextFocus && vim.mode == 'Normal'";
    }
    {
      key = "ctrl+u";
      command = "editor.action.pageUpHover";
      "when" = "editorHoverFocused";
    }
    {
      key = "ctrl+d";
      command = "editor.action.pageDownHover";
      "when" = "editorHoverFocused";
    }
    {
      key = "ctrl+n";
      command = "selectNextCodeAction";
      "when" = "codeActionMenuVisible";
    }
    {
      key = "ctrl+p";
      command = "selectPrevCodeAction";
      "when" = "codeActionMenuVisible";
    }
    {
      key = "ctrl+n";
      command = "quickInput.next";
      "when" = "inQuickInput && quickInputType == 'quickPick'";
    }
    {
      key = "ctrl+p";
      command = "quickInput.previous";
      "when" = "inQuickInput && quickInputType == 'quickPick'";
    }
  ];
in
{
  options.features.development.cursor = {
    enable = lib.mkEnableOption "Cursor AI code editor";
  };

  config = lib.mkIf cfg.enable {
    # Home-manager configuration for user james
    home-manager.users.james = {
      imports = [ ../../lib/cursor.nix ];

      programs.code-cursor = {
        enable = true;
        extensions = codeExtensions;
        userSettings = codeSettings;
        keybindings = codeKeybinds;
        mutableExtensionsDir = false;
      };
    };
  };
}
