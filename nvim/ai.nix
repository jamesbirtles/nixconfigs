# AI assistance via sidekick.nvim: Copilot LSP "Next Edit Suggestions" (NES)
# plus an integrated terminal for AI CLIs. NES needs the Copilot language
# server, so lsp.servers.copilot is enabled here too. Run `:LspCopilotSignIn`
# once to authenticate with GitHub Copilot.
{ ... }:
{
  lsp.servers.copilot.enable = true;

  plugins.sidekick.enable = true;

  # The default inline word-diff overlays old and new text on the same line,
  # which is unreadable for larger edits. Show block-level diffs instead
  # (deleted lines above, added lines below).
  plugins.sidekick.settings.nes.diff.inline = false;

  # <A-l> accepts whatever AI suggestion is in front of you: a sidekick NES
  # edit if one is pending (jump to it, or apply when already there), otherwise
  # the Copilot inline ghost-text completion (insert mode).
  keymaps = [
    {
      mode = [ "n" "i" ];
      key = "<A-l>";
      action.__raw = ''
        function()
          if require('sidekick').nes_jump_or_apply() then
            return
          end
          vim.lsp.inline_completion.get()
        end
      '';
      options.desc = "Accept AI suggestion (NES / inline)";
    }
  ];
}
