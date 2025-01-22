{ config, pkgs, pnpm2nix, ... }:
{
  environment.variables.EDITOR = "nvim";
  environment.systemPackages = with pkgs; [ prettierd ];
  programs.nixvim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    colorschemes.ayu.enable = true;

    globals = {
      mapleader = " ";
    };

    opts = {
      scrolloff = 10;
      number = true;
      relativenumber = true;
      expandtab = true;
      smartindent = true;
      softtabstop = 2;
      tabstop = 2;
      foldlevelstart = 99;
      cursorline = true;
      swapfile = false;
      backup = false;
      undofile = true;
      wrap = true;
      winhl = "NormalFloat:PMenu";
      scroll = 10;
      splitright = true;
    };

    keymaps = [
      { key = "<leader>b"; action = "<cmd>Neotree last toggle reveal<CR>"; options = { desc = "Toggle Neotree"; }; }
      { key = "<leader>tf"; action = "<cmd>Neotree filesystem reveal<CR>"; options = { desc = "Show file explorer"; }; }
      { key = "<leader>tb"; action = "<cmd>Neotree buffers reveal<CR>"; options = { desc = "Show buffer explorer"; }; }
      { key = "<leader>p"; action = "<Nop>"; } # Make <leader>p do nothing so that if we linger on the rest of the command it doesn't paste
      { key = "<leader>pp"; action = ":Telescope resume<CR>"; options = { desc = "Resume last telescope query"; }; }
      { key = "<leader>pg"; action = ":Telescope git_files<CR>"; options = { desc = "Fuzzy find git file"; }; }
      { key = "<leader>pf"; action = ":Telescope find_files<CR>"; options = { desc = "Fuzzy find project files"; }; }
      { key = "<leader>ps"; action = ":Telescope live_grep<CR>"; options = { desc = "Find in project"; }; }
      { key = "<leader>pr"; action = "<cmd>lua require('spectre').toggle()<CR>"; options = { desc = "Find and replace in project"; }; }
      { key = "<leader>lg"; action = ":LazyGit<CR>"; options = { desc = "Open Lazygit in floating window"; }; }
      { key = "<leader>pw"; action = "viwpgvy"; options = { desc = "Paste over word"; }; }
      { key = "<leader>y"; action = "\"+y"; options = { desc = "Copy to system clipboard"; }; }
      { key = "<leader>v"; action = "\"+p"; options = { desc = "Paste from system clipboard"; }; }
      { key = "<leader>w"; action = "<cmd>w<CR>"; options = { desc = "Save file"; }; }
      { mode = "n"; key = "<Esc>"; action = "<cmd>nohlsearch<CR>"; } # Clear highlight on escape

      # LSP Mappings
      { key = "K"; action = "<cmd>lua vim.lsp.buf.hover()<CR>"; }
      { key = "ga"; action = "<cmd>lua vim.lsp.buf.code_action()<CR>"; options = { desc = "Code Actions"; }; }
      { key = "gd"; action = ":Telescope lsp_definitions<CR>"; options = { desc = "Definition"; }; }
      { key = "gt"; action = ":Telescope lsp_type_definitions<CR>"; options = { desc = "Type Definition"; }; }
      # When in neovim 11, I belive these should be: 
      # { key = "gn"; action = "<cmd>lua vim.diagnostic.jump({ count = 1, float = true })<CR>"; }
      # { key = "gp"; action = "<cmd>lua vim.diagnostic.jump({ count = -1, float = true })<CR>"; }
      { key = "gn"; action = "<cmd>lua vim.diagnostic.goto_next()<CR>"; options = { desc = "Next diagnostic"; }; }
      { key = "gp"; action = "<cmd>lua vim.diagnostic.goto_prev()<CR>"; options = { desc = "Previous diagnostic"; }; }
      { key = "gi"; action = ":Telescope lsp_references<CR>"; options = { desc = "References"; }; }
      { key = "gr"; action = "<cmd>lua vim.lsp.buf.rename()<CR>"; options = { desc = "Rename"; }; }
      # Open in a vsplit
      { key = "gvd"; action = ":vsplit | lua vim.lsp.buf.definition()<CR>"; options = { desc = "Definition in vsplit"; }; }

      # Keep current clipboard contents when pasting over selection
      { mode = "x"; key = "p"; action = "pgvy"; }
    ];

    autoGroups = {
      highlight-yank = { clear = true; };
    };
    autoCmd = [
      {
        event = ["TextYankPost"];
        desc = "Highlight when yanking text";
        group = "highlight-yank";
        callback.__raw = "function() vim.highlight.on_yank() end";
      }
    ];

    extraConfigLua = ''
      local get_option = vim.filetype.get_option
      vim.filetype.get_option = function(filetype, option)
        return option == "commentstring"
          and require("ts_context_commentstring.internal").calculate_commentstring()
          or get_option(filetype, option)
      end
    '';

    plugins = {
      typescript-tools = {
        enable = true;
        settings = {
          settings = {
            tsserver_max_memory = 8192;
            separate_diagnostic_server = false;
            expose_as_code_action = "all";
          };
        };
      };
      lsp = {
        enable = true;
        servers = {
          svelte = {
            enable = true;
            # Ensures that svelte knows about changes to typescript files
            onAttach.function = ''
              vim.api.nvim_create_autocmd("BufWritePost", {
                pattern = { "*.js", "*.ts" },
                group = vim.api.nvim_create_augroup("svelte_ondidchangetsorjsfile", { clear = true }),
                callback = function(ctx)
                  client.notify("$/onDidChangeTsOrJsFile", { uri = ctx.match })
                end,
              })
            '';
          };
          # tsserver.extraOptions.init_options = {
          #   # Enable to debug the tsserver, logs are put in .logs in the workspace
          #   # tsserver.logVerbosity = "normal";
          #   # Add the svelte typescript plugin globally to avoid needing to install and configure it in every repo.
          #   # This effectively mimics what the svelte vscode plugin does by default.
          #   plugins = let 
          #     # We have to build this manually as its unfortunately not in the nixpkgs repo. Also they use pnpm which
          #     # makes it a little more awkward.
          #     typescript-svelte-plugin = pnpm2nix.mkPnpmPackage rec {
          #       pname = "typescript-svelte-plugin";
          #       version = "0.3.38";
          #       src = pkgs.fetchFromGitHub {
          #         owner = "sveltejs";
          #         repo = "language-tools";
          #         rev = "typescript-plugin-${version}";
          #         hash = "sha256-ZqeEBtknZfXpW31tpphqUT4Jk3ZnF6SGZFu5fR0J0qU=";
          #       };
          #       installInPlace = true;
          #       distDir = "packages/typescript-plugin";
          #       script = "--filter typescript-svelte-plugin... build";
          #       installPhase = ''
          #         mkdir -p $out/node_modules/typescript-svelte-plugin
          #         cp -LR node_modules/.pnpm/node_modules/. $out/node_modules
          #         cp -LR packages/typescript-plugin/. $out/node_modules/typescript-svelte-plugin
          #       '';
          #     };
          #   in [
          #     {
          #       name = "typescript-svelte-plugin";
          #       location = "${typescript-svelte-plugin}";
          #     }
          #   ];
          # };
          tailwindcss = {
            enable = true;
            filetypes = ["svelte" "html" "css" "postcss" "typescriptreact" "javascriptreact"];
          };
          eslint.enable = true;
          yamlls.enable = true;
          jsonls.enable = true;
          html.enable = true;
          graphql.enable = true;
          cssls.enable = true;
          rust_analyzer = {
            enable = true;
            installCargo = false;
            installRustc = false;
            settings.check.command = "clippy";
          };
        };
      };
      lsp-lines.enable = true;
      indent-blankline.enable = true;
      sleuth.enable = true;
      treesitter = {
        enable = true;
        folding = true;
        nixvimInjections = true;
        settings.highlight.enable = true;
      };
      neo-tree = {
        enable = true;
        closeIfLastWindow = true;
        filesystem.followCurrentFile = {
          enabled = true;
          leaveDirsOpen = true;
        };
      };
      telescope = {
        enable = true;
        extensions.fzf-native.enable = true;
        extensions.file-browser.enable = true;
      };
      cmp = {
        enable = true;
        autoEnableSources = true;
        settings = {
          sources = [
            # { name = "copilot"; }
            { name = "nvim_lsp"; }
            { name = "path"; }
            { name = "buffer"; }
          ];
          mapping = {
            "<C-Space>" = "cmp.mapping.complete()";
            "<C-d>" = "cmp.mapping.scroll_docs(-4)";
            "<C-e>" = "cmp.mapping.close()";
            "<C-f>" = "cmp.mapping.scroll_docs(4)";
            "<CR>" = "cmp.mapping.confirm({ select = false })";
            "<C-p>" = "cmp.mapping(cmp.mapping.select_prev_item(), {'i', 's'})";
            "<C-n>" = "cmp.mapping(cmp.mapping.select_next_item(), {'i', 's'})";
          };
        };
      };
      dressing.enable = true;
      # copilot-lua = {
      #   enable = true;
      #   panel.enabled = false;
      #   suggestion.enabled = false;
      # };
      # copilot-cmp.enable = true;
      # copilot-chat.enable = true;
      fidget.enable = true;
      git-conflict.enable = true;
      gitsigns.enable = true;
      # hardtime.enable = true;
      hmts.enable = true;
      illuminate.enable = true;
      lazygit.enable = true;
      markdown-preview.enable = true;
      nix.enable = true;
      spider = {
        enable = true;
        keymaps.motions = {
          b = "B";
          e = "E";
          ge = "gE";
          w = "W";
        };
        skipInsignificantPunctuation = false;
      };
      twilight.enable = true;
      conform-nvim = {
        enable = true;
        settings = {
          formatters_by_ft = {
            javascript = [["prettierd" "prettier"]];
            typescript = [["prettierd" "prettier"]];
            html = [["prettierd" "prettier"]];
            css = [["prettierd" "prettier"]];
            markdown = [["prettierd" "prettier"]];
            json = [["prettierd" "prettier"]];
            yaml = [["prettierd" "prettier"]];
            graphql = [["prettierd" "prettier"]];
          };
          format_on_save.lsp_format = "fallback";
          notify_on_error = true;
        };
      };
      ts-context-commentstring = {
        enable = true;
        extraOptions.enable_autocmd = false;
      };
      crates.enable = true;
      spectre = {
        enable = true;
        findPackage = pkgs.ripgrep;
        settings = {
          default.replace.cmd = "oxi";
          live_update = true;
        };
      };
      mini = {
        enable = true;
        modules = {
          clue = {
            triggers = [
              { mode = "n"; keys = "<leader>"; }
              { mode = "n"; keys = "g"; }
            ];
          };
          surround = {};
        };
      };
      web-devicons.enable = true;
    };
  };
}
