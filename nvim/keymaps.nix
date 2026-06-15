{ ... }:
{
  keymaps = [
    # File explorer
    {
      key = "<leader>b";
      action.__raw = "function() Snacks.explorer() end";
      options.desc = "Toggle file explorer";
    }

    # Pickers
    {
      key = "<leader>pf";
      action.__raw = "function() Snacks.picker.files() end";
      options.desc = "Find files";
    }
    {
      key = "<leader>pg";
      action.__raw = "function() Snacks.picker.git_files() end";
      options.desc = "Find git files";
    }
    {
      key = "<leader>pp";
      action.__raw = "function() Snacks.picker.commands() end";
      options.desc = "Command palette";
    }
    {
      key = "<leader>ps";
      action.__raw = "function() Snacks.picker.grep() end";
      options.desc = "Search in project";
    }
    {
      key = "<leader>pw";
      action.__raw = "function() Snacks.picker.grep_word() end";
      options.desc = "Search word in project";
    }
    {
      key = "<leader>pb";
      action.__raw = "function() Snacks.picker.buffers() end";
      options.desc = "Buffers";
    }
    {
      key = "<leader>pd";
      action.__raw = "function() Snacks.picker.diagnostics() end";
      options.desc = "Diagnostics";
    }
    {
      key = "<leader>pk";
      action.__raw = "function() Snacks.picker.keymaps() end";
      options.desc = "Keymaps";
    }
    {
      key = "<leader>pl";
      action.__raw = "function() Snacks.picker.resume() end";
      options.desc = "Resume last picker";
    }

    # Save
    {
      key = "<leader>w";
      action = "<cmd>w<cr>";
      options.desc = "Save";
    }
    {
      # disable_autoformat suppresses conform's format-on-save for this write.
      key = "<leader>W";
      action.__raw = ''
        function()
          vim.b.disable_autoformat = true
          vim.cmd.write()
          vim.b.disable_autoformat = false
        end
      '';
      options.desc = "Save (no format)";
    }

    # Format
    {
      key = "<leader>ff";
      action.__raw = "function() require('conform').format({ async = true, lsp_format = 'fallback' }) end";
      options.desc = "Format buffer";
    }

    # Buffer navigation
    {
      key = "<leader>x";
      action.__raw = "function() Snacks.bufdelete() end";
      options.desc = "Close buffer";
    }
    {
      key = "<S-l>";
      action = "<cmd>bnext<cr>";
      options.desc = "Next buffer";
    }
    {
      key = "<S-h>";
      action = "<cmd>bprevious<cr>";
      options.desc = "Previous buffer";
    }

    # Clear search highlight
    {
      mode = "n";
      key = "<Esc>";
      action = "<cmd>nohlsearch<cr>";
    }

    # Keep the unnamed register when pasting over a visual selection
    {
      mode = "x";
      key = "p";
      action = "pgvy";
    }
  ];

  autoCmd = [
    {
      event = [ "TextYankPost" ];
      desc = "Highlight on yank";
      callback.__raw = "function() vim.hl.on_yank() end";
    }
  ];
}
