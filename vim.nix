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
    };

    keymaps = [
      { key = "<leader>b"; action = "<cmd>Neotree last toggle reveal<CR>"; } # Toggle neotree
      { key = "<leader>tf"; action = "<cmd>Neotree filesystem reveal<CR>"; } # Show file explorer
      { key = "<leader>tb"; action = "<cmd>Neotree buffers reveal<CR>"; } # Show buffer explorer
      { key = "<leader>p"; action = "<Nop>"; } # Make <leader>p do nothing so that if we linger on the rest of the command it doesn't paste
      { key = "<leader>pp"; action = ":Telescope resume<CR>"; } # Resume last telescope query
      { key = "<leader>pg"; action = ":Telescope git_files<CR>"; } # Fuzzy find git files
      { key = "<leader>pf"; action = ":Telescope find_files<CR>"; } # Fuzzy find project files
      { key = "<leader>ps"; action = ":Telescope live_grep<CR>"; } # Search in project
      { key = "<leader>pr"; action = "<cmd>lua require('spectre').toggle()<CR>"; } # Replace in project
      { key = "<leader>lg"; action = ":LazyGit<CR>"; } # Open lazy git
      { key = "<leader>pw"; action = "viwpgvy"; } # Paste over word
      { key = "<leader>y"; action = "\"+y"; } # Copy to system clipboard
      { key = "<leader>v"; action = "\"+p"; } # Paste from system clipboard
      { key = "<leader>w"; action = "<cmd>w<CR>"; } # Save file
      { mode = "n"; key = "<Esc>"; action = "<cmd>nohlsearch<CR>"; } # Clear highlight on escape

      # LSP Mappings
      { key = "K"; action = ":Lspsaga hover_doc<CR>"; }
      { key = "gh"; action = ":Lspsaga hover_doc<CR>"; }
      { key = "ga"; action = ":Lspsaga code_action<CR>"; }
      { key = "gD"; action = ":Lspsaga peek_definition<CR>"; }
      { key = "gd"; action = ":Telescope lsp_definitions<CR>"; }
      { key = "gT"; action = ":Lspsaga peek_type_definition<CR>"; }
      { key = "gt"; action = ":Telescope lsp_type_definitions<CR>"; }
      { key = "gn"; action = ":Lspsaga diagnostic_jump_next<CR>"; }
      { key = "gp"; action = ":Lspsaga diagnostic_jump_prev<CR>"; }
      { key = "gi"; action = ":Telescope lsp_references<CR>"; }
      { key = "gr"; action = ":Lspsaga rename<CR>"; }

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
          tsserver.enable = true;
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
          tailwindcss.enable = true;
          eslint.enable = true;
          yamlls.enable = true;
          jsonls.enable = true;
          html.enable = true;
          graphql.enable = true;
          cssls.enable = true;
          rust-analyzer = {
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
            { name = "copilot"; }
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
      lspsaga = {
        enable = true;
        lightbulb.enable = false;
      };
      copilot-lua = {
        enable = true;
        panel.enabled = false;
        suggestion.enabled = false;
      };
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
        formattersByFt = {
          javascript = [["prettierd" "prettier"]];
          typescript = [["prettierd" "prettier"]];
          html = [["prettierd" "prettier"]];
          css = [["prettierd" "prettier"]];
          markdown = [["prettierd" "prettier"]];
          json = [["prettierd" "prettier"]];
          yaml = [["prettierd" "prettier"]];
        };
        formatOnSave = {
          timeoutMs = 500;
          lspFallback = true;
        };
        notifyOnError = true;
      };
      ts-context-commentstring = {
        enable = true;
        extraOptions.enable_autocmd = false;
      };
      crates-nvim.enable = true;
      spectre = {
        enable = true;
        findPackage = pkgs.ripgrep;
        settings = {
          default.replace.cmd = "oxi";
          live_update = true;
        };
      };
    };
  };
}
