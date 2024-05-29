{ config, pkgs, pnpm2nix, ... }:
{
  environment.variables.EDITOR = "nvim";
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
    };

    keymaps = [
      { key = "<leader>b"; action = ":CHADopen<CR>"; } # Open file explorer to the left
      { key = "<leader>pp"; action = ":Telescope git_files<CR>"; } # Fuzzy find git files
      { key = "<leader>pf"; action = ":Telescope find_files<CR>"; } # Fuzzy find project files
      { key = "<leader>lg"; action = ":LazyGit<CR>"; } # Open lazy git
      { key = "W"; action = "w"; } # w is changed by spider, but sometimes the old behaviour is useful
      { key = "B"; action = "b"; } # b is changed by spider, but sometimes the old behaviour is useful
      { key = "E"; action = "e"; } # e is changed by spider, but sometimes the old behaviour is useful
      { key = "gE"; action = "ge"; } # ge is changed by spider, but sometimes the old behaviour is useful

      # LSP Mappings
      { key = "gh"; action = ":Lspsaga hover_doc<CR>"; }
      { key = "ga"; action = ":Lspsaga code_action<CR>"; }
      { key = "gd"; action = ":Lspsaga peek_definition<CR>"; }
      { key = "gD"; action = ":Lspsaga goto_definition<CR>"; }
      { key = "gt"; action = ":Lspsaga peek_type_definition<CR>"; }
      { key = "gT"; action = ":Lspsaga goto_type_definition<CR>"; }
      { key = "gn"; action = ":Lspsaga diagnostic_jump_next<CR>"; }
      { key = "gp"; action = ":Lspsaga diagnostic_jump_prev<CR>"; }
      { key = "gi"; action = ":Lspsaga finder<CR>"; }
      { key = "gr"; action = ":Lspsaga rename<CR>"; }

      # Keep current clipboard contents when pasting over selection
      { mode = "x"; key = "p"; action = "pgvy"; }
    ];

    plugins = {
      lsp = {
        enable = true;
        servers = {
          svelte.enable = true;
          tsserver.enable = true;
          tsserver.extraOptions.init_options = {
            # Add the svelte typescript plugin globally to avoid needing to install and configure it in every repo.
            # This effectively mimics what the svelte vscode plugin does by default.
            plugins = let 
              # We have to build this manually as its unfortunately not in the nixpkgs repo. Also they use pnpm which
              # makes it a little more awkward.
              typescript-svelte-plugin = pnpm2nix.mkPnpmPackage rec {
                pname = "typescript-svelte-plugin";
                version = "0.3.38";
                src = pkgs.fetchFromGitHub {
                  owner = "sveltejs";
                  repo = "language-tools";
                  rev = "typescript-plugin-${version}";
                  hash = "sha256-ZqeEBtknZfXpW31tpphqUT4Jk3ZnF6SGZFu5fR0J0qU=";
                };
                installInPlace = true;
                distDir = "packages/typescript-plugin";
                script = "--filter typescript-svelte-plugin build";
              };
            in [
              {
                name = "typescript-svelte-plugin";
                location = "${typescript-svelte-plugin}";
              }
            ];
          };
          tailwindcss.enable = true;
          eslint.enable = true;
          yamlls.enable = true;
          jsonls.enable = true;
          html.enable = true;
          graphql.enable = true;
          cssls.enable = true;
        };
      };
      lsp-lines.enable = true;
      indent-blankline.enable = true;
      indent-o-matic.enable = true;
      treesitter = {
        enable = true;
        folding = true;
        nixvimInjections = true;
      };
      treesitter-context.enable = true;
      chadtree.enable = true;
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
            "<CR>" = "cmp.mapping.confirm({ select = true })";
            "<C-p>" = "cmp.mapping(cmp.mapping.select_prev_item(), {'i', 's'})";
            "<C-n>" = "cmp.mapping(cmp.mapping.select_next_item(), {'i', 's'})";
          };
        };
      };
      lspsaga = {
        enable = true;
        lightbulb.enable = false;
      };
      barbar.enable = true;
      copilot-lua = {
        enable = true;
        panel.enabled = false;
        suggestion.enabled = false;
      };
      fidget.enable = true;
      git-conflict.enable = true;
      gitsigns.enable = true;
      hardtime.enable = true;
      hmts.enable = true;
      illuminate.enable = true;
      lazygit.enable = true;
      markdown-preview.enable = true;
      nix.enable = true;
      spider = {
        enable = true;
        keymaps.motions = {
          b = "b";
          e = "e";
          ge = "ge";
          w = "w";
        };
        skipInsignificantPunctuation = false;
      };
      twilight.enable = true;
    };
  };
}
