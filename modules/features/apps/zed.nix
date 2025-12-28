{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.features.apps.zed;
in
{
  options.features.apps.zed = {
    enable = lib.mkEnableOption "Zed code editor";
  };

  config = lib.mkIf cfg.enable {
    # Home-manager configuration for user james
    home-manager.users.james = {
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
              "space p r" = [
                "pane::DeploySearch"
                { replace_enabled = true; }
              ];
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
              shift-y = [
                "workspace::SendKeystrokes"
                "y $"
              ];
            };
          }
          {
            context = "Editor && showing_completions";
            bindings = {
              tab = null;
            };
          }
        ];
        userSettings = {
          icon_theme = "Catppuccin Frappé";
          context_servers = {
            effect-mcp = {
              source = "custom";
              command = "npx";
              args = [ "@niklaserik/effect-mcp" ];
              env = null;
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
              model = "claude-opus-4-1";
            };
            default_profile = "write";
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
                typescript = {
                  tsserver = {
                    maxTsServerMemory = 16184;
                  };
                };
                javascript = {
                  tsserver = {
                    maxTsServerMemory = 16184;
                  };
                };
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
    };
  };
}
