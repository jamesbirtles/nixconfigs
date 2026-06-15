# Session persistence via persistence.nvim: auto-saves a session per directory
# (keyed by cwd) on exit, and auto-restores it when nvim is launched in that
# directory with no file arguments.
{ ... }:
{
  plugins.persistence = {
    enable = true;
    settings = {
      # Save the session whenever at least one real file buffer is open.
      need = 1;
    };
  };

  keymaps = [
    {
      key = "<leader>qs";
      action.__raw = "function() require('persistence').load() end";
      options.desc = "Restore session (this dir)";
    }
    {
      key = "<leader>ql";
      action.__raw = "function() require('persistence').load({ last = true }) end";
      options.desc = "Restore last session";
    }
    {
      key = "<leader>qd";
      action.__raw = "function() require('persistence').stop() end";
      options.desc = "Stop saving session";
    }
  ];

  autoCmd = [
    {
      event = [ "StdinReadPre" ];
      desc = "Mark stdin start to skip session auto-restore";
      callback.__raw = "function() vim.g.started_with_stdin = true end";
    }
    {
      event = [ "VimEnter" ];
      # nested so restored buffers fire FileType/LspAttach etc.
      nested = true;
      desc = "Auto-restore session when launched with no file args";
      callback.__raw = ''
        function()
          if vim.fn.argc() == 0 and not vim.g.started_with_stdin then
            -- No-op when no session exists for the cwd.
            require('persistence').load()
          end
        end
      '';
    }
  ];
}
