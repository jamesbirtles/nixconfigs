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

  programs.zed-editor = {
    enable = true;
    extensions = [
      "catppuccin-icons"
      "svelte"
      "github-theme"
      "postgres-context-server"
    ];
    userKeymaps = [
      {
        context = "VimControl && !menu";
        bindings = {
          "space p f" = "file_finder::Toggle";
          "space p p" = "command_palette::Toggle";
          "space p s" = "pane::DeploySearch";
          "space p r" = ["pane::DeploySearch" { replace_enabled = true; }];
          "space w" = "workspace::Save";
          "space W" = "workspace::SaveWithoutFormat";
          "space b" = "workspace::ToggleLeftDock";

          "g a" = "editor::ToggleCodeActions";
          "g r" = "editor::Rename";
          "g n" = "editor::GoToDiagnostic";
          "g p" = "editor::GoToPreviousDiagnostic";
        };
      }
      {
        context = "vim_mode == normal && !menu";
        bindings = {
          shift-y = ["workspace::SendKeystrokes" "y $"]; # Use neovim's yank behavior: yank to end of line.
        };
      }
      {
        context = "Editor && showing_completions";
        bindings = {
          # Disable tab from completing suggestion (I use enter and only ever accidentally use tab when trying to complete the AI completion)
          tab = null;
        };
      }
    ];
    userSettings = {
      icon_theme = "Catppuccin Frappé";
      context_servers = {
        effect-mcp = {
          source = "custom";
          command = {
            path = "npx";
            args = ["@niklaserik/effect-mcp"];
            env = null;
          };
          settings = {};
        };
        postgres-context-server = {
          source = "extension";
          settings = {
            database_url = "postgresql://postgres:postgres@127.0.0.1:54322/postgres";
          };
        };
      };
      agent = {
        always_allow_tool_actions = true;
        default_model = {
          provider = "zed.dev";
          model = "claude-sonnet-4";
        };
        default_profile = "write";
        version = "2";
      };
      features = {
          edit_prediction_provider = "zed";
      };
      ui_font_size = 16;
      buffer_font_size = 16;
      buffer_font_family = "BerkeleyMono Nerd Font";
      buffer_line_height = "standard";
      theme = {
          mode = "system";
          light = "One Light";
          dark = "Github Dark Dimmed";
      };
      vim_mode = true;
      tab_size = 4;
      auto_signature_help = true;
      middle_click_paste = false;
      vim = {
        toggle_relative_line_numbers = true;
      };
      lsp = {
        vtsls = {
          settings = {
            # For TypeScript:
            typescript = { tsserver = { maxTsServerMemory = 16184; }; };
            # For JavaScript:
            javascript = { tsserver = { maxTsServerMemory = 16184; }; };
          };
        };
        svelte-language-server = {
          binary = {
            arguments = [
              "--max-old-space-size=10240"
              "/home/james/.local/share/zed/extensions/work/svelte/node_modules/svelte-language-server/bin/server.js"
              "--stdio"
            ];
          };
          initialization_options = {
            configuration = {
              svelte = {
                plugin = {
                  # Can't get this to work at all
                  html = {
                    tagComplete = {
                      enable = false;
                    };
                  };
                };
              };
            };
          };
        };
      };
    };
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

