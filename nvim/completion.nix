# Native completion: vim.lsp.completion is enabled per-buffer on LspAttach
# (lsp.nix) with autotrigger; completeopt is set in options.nix. Snippets use
# the built-in vim.snippet engine. These keymaps drive the native pop-up and
# snippet tabstops.
{ ... }:
{
  keymaps = [
    # Manually trigger completion.
    {
      mode = "i";
      key = "<C-Space>";
      action.__raw = "function() vim.lsp.completion.get() end";
      options.desc = "Trigger completion";
    }

    # <Tab> / <S-Tab>: navigate the pop-up, otherwise jump snippet tabstops,
    # otherwise behave as a normal tab. Written as expr returning key sequences
    # so there are no side effects inside the expression.
    {
      mode = [ "i" "s" ];
      key = "<Tab>";
      action.__raw = ''
        function()
          if vim.fn.pumvisible() == 1 then return "<C-n>" end
          if vim.snippet.active({ direction = 1 }) then
            return "<cmd>lua vim.snippet.jump(1)<cr>"
          end
          return "<Tab>"
        end
      '';
      options = {
        expr = true;
        silent = true;
        desc = "Completion next / snippet forward / tab";
      };
    }
    {
      mode = [ "i" "s" ];
      key = "<S-Tab>";
      action.__raw = ''
        function()
          if vim.fn.pumvisible() == 1 then return "<C-p>" end
          if vim.snippet.active({ direction = -1 }) then
            return "<cmd>lua vim.snippet.jump(-1)<cr>"
          end
          return "<S-Tab>"
        end
      '';
      options = {
        expr = true;
        silent = true;
        desc = "Completion prev / snippet backward";
      };
    }
  ];
}
