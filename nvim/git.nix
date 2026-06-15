# Git: gutter signs via gitsigns, lazygit via snacks.
{ ... }:
{
  plugins.gitsigns = {
    enable = true;
    settings.signcolumn = true;
  };

  keymaps = [
    {
      key = "<leader>lg";
      action.__raw = "function() Snacks.lazygit.open() end";
      options.desc = "Lazygit";
    }
    {
      key = "<leader>gb";
      action.__raw = "function() require('gitsigns').blame_line() end";
      options.desc = "Git blame line";
    }
    {
      key = "]h";
      action.__raw = "function() require('gitsigns').nav_hunk('next') end";
      options.desc = "Next git hunk";
    }
    {
      key = "[h";
      action.__raw = "function() require('gitsigns').nav_hunk('prev') end";
      options.desc = "Previous git hunk";
    }
  ];
}
