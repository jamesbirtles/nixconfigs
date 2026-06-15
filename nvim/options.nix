{ ... }:
{
  opts = {
    # Indentation — 4 spaces.
    expandtab = true;
    smartindent = true;
    tabstop = 4;
    softtabstop = 4;
    shiftwidth = 4;

    # Relative + absolute line numbers.
    number = true;
    relativenumber = true;

    # Always show the sign column so gitsigns/diagnostics don't shift text.
    signcolumn = "yes";
    cursorline = true;

    # Keep some context around the cursor.
    scrolloff = 10;

    # Wrapping & folding.
    wrap = true;
    foldlevelstart = 99;

    # Splits open down/right.
    splitright = true;
    splitbelow = true;

    # No swap/backup; persistent undo instead.
    swapfile = false;
    backup = false;
    undofile = true;

    # Native completion: menu even for one item, don't auto-select, show docs
    # popup, and use the fuzzy matcher (Neovim 0.11+).
    completeopt = [
      "menuone"
      "noselect"
      "popup"
      "fuzzy"
    ];

    # Float windows reuse the popup-menu highlight.
    winhl = "NormalFloat:PMenu";

    # Default border on all floating windows (LSP hover, diagnostics, etc.).
    winborder = "rounded";

    # What persistence.nvim captures in a session (buffers, tabs, layout, cwd).
    sessionoptions = [
      "buffers"
      "curdir"
      "folds"
      "globals"
      "tabpages"
      "winsize"
      "winpos"
      "localoptions"
    ];

    # Snappier CursorHold (drives LSP document highlight).
    updatetime = 250;

    termguicolors = true;
  };

  # Show diagnostics inline to the right of the line.
  diagnostic.settings.virtual_text = true;
}
