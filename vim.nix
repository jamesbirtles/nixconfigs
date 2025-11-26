{
  config,
  pkgs,
  ...
}:
let
  nv = config.lib.nixvim;
in
{
  environment.variables.EDITOR = "nvim";
  programs.nixvim = {
    enable = true;
    viAlias = true;
    vimAlias = true;

    extraPackages = with pkgs; [
      nixfmt-rfc-style
      dwt1-shell-color-scripts
    ];

    colorschemes.ayu.enable = true;

    # Use system clipboard for everything
    clipboard.register = "unnamedplus";

    # show diagnostics to the right of line
    diagnostic.settings.virtual_text = true;

    globals.mapleader = " ";

    opts = {
      scrolloff = 10;
      number = true;
      relativenumber = true;
      expandtab = true;
      smartindent = true;
      softtabstop = 4;
      tabstop = 4;
      foldlevelstart = 99;
      cursorline = true;
      swapfile = false;
      backup = false;
      undofile = true;
      wrap = true;
      winhl = "NormalFloat:PMenu";
      scroll = 10;
      splitright = true;
      completeopt = [
        "menuone"
        "noselect"
        "popup"
      ];

      # time in millis before CursorHold event is fired
      updatetime = 250;
    };

    keymaps = [
      {
        key = "<leader>b";
        options.desc = "Toggle File Explorer";
        action = nv.mkRaw ''
          function()
            Snacks.explorer.open()
          end
        '';
      }
      {
        key = "<leader>pp";
        options.desc = "Resume last picker session";
        action = nv.mkRaw ''
          function()
            Snacks.picker.resume()
          end
        '';
      }
      {
        key = "<leader>pg";
        options.desc = "Fuzzy find git file";
        action = nv.mkRaw ''
          function()
            Snacks.picker.git_files()
          end
        '';
      }
      {
        key = "<leader>pf";
        options.desc = "Fuzzy find project files";
        action = nv.mkRaw ''
          function()
            Snacks.picker.files()
          end
        '';
      }
      {
        key = "<leader>ps";
        options.desc = "Find in project";
        action = nv.mkRaw ''
          function()
            Snacks.picker.grep()
          end
        '';
      }
      {
        key = "<leader>pw";
        options.desc = "Find selection in project";
        action = nv.mkRaw ''
          function()
            Snacks.picker.grep_word()
          end
        '';
      }
      {
        key = "<leader>pk";
        options.desc = "Search keymap";
        action = nv.mkRaw ''
          function()
            Snacks.picker.keymaps()
          end
        '';
      }
      {
        key = "<leader>pr";
        action = "<cmd>lua require('spectre').toggle()<CR>";
        options.desc = "Find and replace in project";
      }
      {
        key = "<leader>lg";
        action = nv.mkRaw ''
          function()
            Snacks.lazygit.open()
          end
        '';
        options.desc = "Open Lazygit in floating window";
      }
      {
        key = "<leader>pw";
        action = "viwpgvy";
        options.desc = "Paste over word";
      }
      {
        key = "<leader>w";
        action = "<cmd>w<CR>";
        options.desc = "Save file";
      }
      {
        mode = "n";
        key = "<Esc>";
        action = "<cmd>nohlsearch<CR>";
        options.desc = "Clear highlight";
      }

      {
        # Keep current clipboard contents when pasting over selection
        mode = "x";
        key = "p";
        action = "pgvy";
      }
    ];

    autoCmd = [
      {
        event = [ "TextYankPost" ];
        desc = "Highlight when yanking text";
        callback.__raw = "function() vim.highlight.on_yank() end";
      }
      {
        event = [ "LspAttach" ];
        desc = "Set up lsp highlighting under cursor";
        callback = nv.mkRaw ''
          function(args)
            local bufnr = args.buf
            pcall(vim.keymap.del, 'n', 'grr', { buffer = bufnr })
            pcall(vim.keymap.del, 'n', 'gra', { buffer = bufnr })
            pcall(vim.keymap.del, 'n', 'grn', { buffer = bufnr })
            pcall(vim.keymap.del, 'n', 'gri', { buffer = bufnr })
            pcall(vim.keymap.del, 'n', 'grt', { buffer = bufnr })
            pcall(vim.keymap.del, 'v', 'gra', { buffer = bufnr })

            vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
              buffer = bufnr,
              callback = function()
                vim.lsp.buf.document_highlight()
              end,
            })
            vim.api.nvim_create_autocmd({ "CursorMoved", "CursorHoldI" }, {
              buffer = bufnr,
              callback = function()
                vim.lsp.buf.clear_references()
              end,
            })
            vim.lsp.completion.enable(true, args.data.client_id, args.buf, { autotrigger = true })
          end
        '';
      }
    ];

    plugins.lspconfig.enable = true;

    lsp.keymaps = [
      {
        key = "<leader>ff";
        options.desc = "Format file";
        lspBufAction = "format";
      }
      {
        key = "gh";
        options.desc = "Lsp Hover";
        lspBufAction = "hover";
      }
      {
        key = "gj";
        options.desc = "Diagnostic Float";
        action = nv.mkRaw "vim.diagnostic.open_float";
      }
      {
        key = "ga";
        options.desc = "Code Actions";
        lspBufAction = "code_action";
      }
      {
        key = "gd";
        options.desc = "Go to definition";
        action = nv.mkRaw ''
          function()
            Snacks.picker.lsp_definitions()
          end
        '';
      }
      {
        key = "gt";
        options.desc = "Go to type definition";
        action = nv.mkRaw ''
          function()
            Snacks.picker.lsp_type_definitions()
          end
        '';
      }
      {
        key = "gi";
        options.desc = "References";
        action = nv.mkRaw ''
          function()
            Snacks.picker.lsp_references()
          end
        '';
      }
      {
        key = "gn";
        options.desc = "Go to next diagnostic";
        action = nv.mkRaw ''
          function()
            vim.diagnostic.jump({ count = 1, float = true })
          end
        '';
      }
      {
        key = "gp";
        options.desc = "Go to previous diagnostic";
        action = nv.mkRaw ''
          function()
            vim.diagnostic.jump({ count = 1, float = true })
          end
        '';
      }
      {
        key = "gr";
        options.desc = "Rename";
        lspBufAction = "rename";
      }
    ];

    plugins.treesitter = {
      enable = true;
      settings = {
        highlight.enable = true;
        indent.enable = true;
      };
    };
    plugins.fidget.enable = true;
    # plugins.lazy.enable = true;
    plugins.snacks = {
      enable = true;
      settings = {
        indent.enabled = true;
        lazygit.enabled = true;
        explorer.enabled = true;
        input.enabled = true;
        notifier.enabled = true;
        scroll.enabled = true;
        statuscolumn.enabled = true;
        # dashboard.example = "github";
        dashboard.sections = [
          { section = "header"; }
          {
            pane = 2;
            section = "terminal";
            cmd = "colorscript -e square";
            height = 5;
            padding = 1;
          }
          {
            section = "keys";
            gap = 1;
            padding = 1;
          }
          {
            pane = 2;
            icon = " ";
            desc = "Browse Repo";
            padding = 1;
            key = "b";
            action = nv.mkRaw ''
              function()
                Snacks.gitbrowse()
              end
            '';
          }
          {
            __raw = ''
              function()
                local in_git = Snacks.git.get_root() ~= nil
                local cmds = {
                  {
                    title = "Notifications",
                    cmd = "gh notify -s -a -n5",
                    action = function()
                      vim.ui.open("https://github.com/notifications")
                    end,
                    key = "n",
                    icon = " ",
                    height = 5,
                    enabled = true,
                  },
                  {
                    title = "Open Issues",
                    cmd = "gh issue list -L 3",
                    key = "i",
                    action = function()
                      vim.fn.jobstart("gh issue list --web", { detach = true })
                    end,
                    icon = " ",
                    height = 7,
                  },
                  {
                    icon = " ",
                    title = "Open PRs",
                    cmd = "gh pr list -L 3",
                    key = "P",
                    action = function()
                      vim.fn.jobstart("gh pr list --web", { detach = true })
                    end,
                    height = 7,
                  },
                  {
                    icon = " ",
                    title = "Git Status",
                    cmd = "git --no-pager diff --stat -B -M -C",
                    height = 10,
                  },
                }
                return vim.tbl_map(function(cmd)
                  return vim.tbl_extend("force", {
                    pane = 2,
                    section = "terminal",
                    enabled = in_git,
                    padding = 1,
                    ttl = 5 * 60,
                    indent = 3,
                  }, cmd)
                end, cmds)
              end
            '';
          }
        ];
      };
    };
    # plugins.gitsigns = {
    #   enable = true;
    #   settings.current_line_blame = true;
    # };
    plugins.hardtime.enable = true;
    plugins.mini = {
      enable = true;
      modules = {
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
          ];
        };
      };
    };
    plugins.web-devicons.enable = true;

    # plugins.cmp = {
    #   enable = true;
    #   settings = {
    #     sources = [
    #       { name = "nvim_lsp"; }
    #       # { name = "supermaven"; }
    #       # { name = "path"; }
    #       # { name = "buffer"; }
    #     ];
    #     mapping = {
    #       "<C-d>" = "cmp.mapping.scroll_docs(-4)";
    #       "<C-u>" = "cmp.mapping.scroll_docs(4)";
    #       "<C-e>" = "cmp.mapping.abort()";
    #       "<A-l>" = "cmp.mapping.confirm({ select = true })";
    #       "<C-p>" = "cmp.mapping(cmp.mapping.select_prev_item(), {'i', 's'})";
    #       "<C-n>" = "cmp.mapping(cmp.mapping.select_next_item(), {'i', 's'})";
    #     };
    #   };
    # };
    plugins.supermaven = {
      enable = true;
      settings = {
        keymaps = {
          accept_suggestion = "<A-l>";
          accept_word = "<A-L>";
        };
      };
    };

    # Nix
    plugins.nix.enable = true;
    lsp.servers.nixd = {
      enable = true;
      config = {
        formatting.command = "nixfmt";
      };
    };

    # Rust
    lsp.servers.rust_analyzer.enable = true;
    plugins.crates.enable = true;

    # Frontend
    lsp.servers.vtsls.enable = true;
    lsp.servers.tailwindcss.enable = true;
    lsp.servers.html.enable = true;
    lsp.servers.cssls.enable = true;

    # Misc
    lsp.servers.jsonls.enable = true;
    lsp.servers.yamlls.enable = true;

    plugins = {
      #   sleuth.enable = true;
      #   dressing.enable = true;
      #   fidget.enable = true;
      #   git-conflict.enable = true;
      #   gitsigns.enable = true;
      #   hmts.enable = true;
      #   illuminate.enable = true;
      #   lazygit.enable = true;
      #   markdown-preview.enable = true;
      #   nix.enable = true;
      #   spider = {
      #     enable = true;
      #     keymaps.motions = {
      #       b = "B";
      #       e = "E";
      #       ge = "gE";
      #       w = "W";
      #     };
      #     settings.skipInsignificantPunctuation = false;
      #   };
      #   twilight.enable = true;
      #   conform-nvim = {
      #     enable = true;
      #     settings = {
      #       formatters_by_ft = {
      #         javascript = [["prettierd" "prettier"]];
      #         typescript = [["prettierd" "prettier"]];
      #         html = [["prettierd" "prettier"]];
      #         css = [["prettierd" "prettier"]];
      #         markdown = [["prettierd" "prettier"]];
      #         json = [["prettierd" "prettier"]];
      #         yaml = [["prettierd" "prettier"]];
      #         graphql = [["prettierd" "prettier"]];
      #       };
      #       format_on_save.lsp_format = "fallback";
      #       notify_on_error = true;
      #     };
      #   };
      #   ts-context-commentstring = {
      #     enable = true;
      #     settings.enable_autocmd = false;
      #   };
      #   crates.enable = true;
      #   spectre = {
      #     enable = true;
      #     settings = {
      #       default.replace.cmd = "oxi";
      #       live_update = true;
      #     };
      #   };
    };
  };
}
