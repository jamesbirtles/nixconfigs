{ ... }:
{
  plugins.lspconfig.enable = true;

  lsp.servers = {
    nixd.enable = true;

    rust_analyzer.enable = true;

    vtsls.enable = true;
    svelte.enable = true;
    eslint.enable = true;
    tailwindcss.enable = true;
    html.enable = true;
    cssls.enable = true;

    jsonls.enable = true;
    yamlls.enable = true;
    taplo.enable = true;
  };

  plugins.crates.enable = true;
  plugins.nix.enable = true;

  # Formatting is handled by conform, not the LSP servers. Prettier covers the
  # web filetypes, nixfmt covers Nix, and lsp_format = "fallback" lets servers
  # like rust_analyzer and taplo format the rest. autoInstall pulls the
  # formatter binaries into the package.
  plugins.conform-nvim = {
    enable = true;
    autoInstall.enable = true;
    settings = {
      default_format_opts.lsp_format = "fallback";
      formatters_by_ft = {
        javascript = [ "prettier" ];
        javascriptreact = [ "prettier" ];
        typescript = [ "prettier" ];
        typescriptreact = [ "prettier" ];
        svelte = [ "prettier" ];
        css = [ "prettier" ];
        scss = [ "prettier" ];
        less = [ "prettier" ];
        html = [ "prettier" ];
        json = [ "prettier" ];
        jsonc = [ "prettier" ];
        yaml = [ "prettier" ];
        markdown = [ "prettier" ];
        graphql = [ "prettier" ];
        nix = [ "nixfmt" ];
      };
      # disable_autoformat (set by <leader>W) skips format-on-save.
      format_on_save = ''
        function(bufnr)
          if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
            return
          end
          return { timeout_ms = 1000, lsp_format = "fallback" }
        end
      '';
    };
  };

  lsp.keymaps = [
    {
      key = "gh";
      lspBufAction = "hover";
      options.desc = "Hover";
    }
    {
      key = "ga";
      lspBufAction = "code_action";
      options.desc = "Code action";
    }
    {
      key = "gr";
      lspBufAction = "rename";
      options.desc = "Rename";
    }
    {
      key = "gd";
      action.__raw = "function() Snacks.picker.lsp_definitions() end";
      options.desc = "Go to definition";
    }
    {
      key = "gt";
      action.__raw = "function() Snacks.picker.lsp_type_definitions() end";
      options.desc = "Go to type definition";
    }
    {
      key = "gi";
      action.__raw = "function() Snacks.picker.lsp_references() end";
      options.desc = "References";
    }
    {
      key = "gj";
      action.__raw = "function() vim.diagnostic.open_float() end";
      options.desc = "Diagnostic float";
    }
    {
      key = "gn";
      action.__raw = "function() vim.diagnostic.jump({ count = 1, float = true }) end";
      options.desc = "Next diagnostic";
    }
    {
      key = "gp";
      action.__raw = "function() vim.diagnostic.jump({ count = -1, float = true }) end";
      options.desc = "Previous diagnostic";
    }
  ];

  lsp.onAttach = ''
    -- Delete the default gr* maps so `gr` resolves to rename without a
    -- key-sequence timeout. They are global, and the set grows across Neovim
    -- versions (grx landed in 0.12), so match them dynamically.
    for _, mode in ipairs({ 'n', 'x' }) do
      for _, m in ipairs(vim.api.nvim_get_keymap(mode)) do
        if m.lhs and vim.startswith(m.lhs, 'gr') and #m.lhs > 2 then
          pcall(vim.keymap.del, mode, m.lhs)
        end
      end
    end

    if client:supports_method('textDocument/completion') then
      vim.lsp.completion.enable(true, client.id, bufnr, { autotrigger = true })
    end

    if client:supports_method('textDocument/documentHighlight') then
      local grp = vim.api.nvim_create_augroup('lsp-highlight-' .. bufnr, { clear = true })
      vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
        group = grp,
        buffer = bufnr,
        callback = function() vim.lsp.buf.document_highlight() end,
      })
      vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
        group = grp,
        buffer = bufnr,
        callback = function() vim.lsp.buf.clear_references() end,
      })
    end
  '';
}
