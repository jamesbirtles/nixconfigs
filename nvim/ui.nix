{ ... }:
{
  # GitHub Dark Dimmed.
  colorschemes.github-theme.enable = true;
  colorscheme = "github_dark_dimmed";

  # Icons (used by snacks, bufferline, dropbar, mini.statusline).
  plugins.web-devicons.enable = true;

  # The snacks suite: picker, explorer, lazygit, notifier, indent guides,
  # smooth scroll, fancy status column, better vim.ui.input, and a dashboard.
  plugins.snacks = {
    enable = true;
    settings = {
      picker.enabled = true;
      explorer.enabled = true;
      lazygit.enabled = true;
      notifier.enabled = true;
      input = {
        enabled = true;
        # Anchor the prompt just above the cursor instead of the editor top.
        win = {
          relative = "cursor";
          row = -3;
          col = 0;
        };
      };
      indent.enabled = true;
      scroll.enabled = true;
      statuscolumn.enabled = true;
      dashboard = {
        enabled = true;
        # The default dashboard's "startup" section pulls in lazy.nvim's stats
        # module, which doesn't exist under Nix-managed plugins. Use explicit
        # sections that don't depend on it.
        sections = [
          { section = "header"; }
          {
            section = "keys";
            gap = 1;
            padding = 1;
          }
          {
            icon = " ";
            title = "Recent Files";
            section = "recent_files";
            indent = 2;
            padding = 1;
          }
          {
            icon = " ";
            title = "Projects";
            section = "projects";
            indent = 2;
            padding = 1;
          }
        ];
      };
    };
  };

  # mini: statusline, key hints (which-key style), and auto-pairs.
  plugins.mini = {
    enable = true;
    modules = {
      statusline = {
        use_icons = true;
      };
      # Text objects; "cover" keeps vi(/ci( from jumping to a pair the cursor
      # isn't already inside.
      ai = {
        search_method = "cover";
      };
      pairs = { };
      clue = {
        triggers = [
          {
            mode = "n";
            keys = "<leader>";
          }
          {
            mode = "n";
            keys = "g";
          }
          {
            mode = "x";
            keys = "<leader>";
          }
        ];
      };
    };
  };

  # Editor tabs and LSP symbol breadcrumbs.
  plugins.bufferline.enable = true;
  plugins.dropbar.enable = true;

  # LSP progress notifications.
  plugins.fidget.enable = true;

  # Treesitter highlighting + indentation.
  plugins.treesitter = {
    enable = true;
    settings = {
      highlight.enable = true;
      indent.enable = true;
    };
  };
}
