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
      # Prefill the live-grep prompt with the word under the cursor, but only
      # when it's a real identifier (letters/digits/underscore) — not brackets
      # or other punctuation. The prompt stays editable either way.
      action.__raw = ''
        function()
          -- Word under the cursor, but only when the cursor is actually on a
          -- word char. `<cword>` otherwise scans forward to the next word
          -- (e.g. on the `?` in `field?: boolean` it grabs `boolean`).
          local function word_under_cursor()
            local line = vim.api.nvim_get_current_line()
            local col = vim.fn.col(".")
            return line:sub(col, col):match("[%w_]") and vim.fn.expand("<cword>") or ""
          end

          local search
          local ok, node = pcall(vim.treesitter.get_node)
          if ok and node then
            local t = node:type()
            if t:match("identifier$") then
              -- Code identifier: use the node's exact text.
              search = vim.treesitter.get_node_text(node, 0)
            elseif t:match("string") or t:match("comment") or t:match("text") then
              -- Free-form text (string contents, comments, JSX children):
              -- prefill the word under the cursor.
              search = word_under_cursor()
            else
              -- Punctuation / operators / keywords: leave the prompt empty.
              search = ""
            end
          else
            -- No treesitter parser for this buffer.
            search = word_under_cursor()
          end

          Snacks.picker.grep({ search = search })
        end
      '';
      options.desc = "Search in project";
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
