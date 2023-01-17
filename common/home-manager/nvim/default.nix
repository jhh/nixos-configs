{ config, pkgs, ... }:
let
  pluginWithConfig = plugin: {
    plugin = plugin;
    config = ''
      lua require 'j3ff.${builtins.replaceStrings ["."] ["-"] plugin.pname}'
    '';
  };

  custom-plugins = pkgs.callPackage ./custom-plugins.nix {
    inherit (pkgs.vimUtils) buildVimPlugin;
    inherit (pkgs) fetchFromGitHub;
  };

  plugins = pkgs.vimPlugins // custom-plugins;

  # https://github.com/NixOS/nixpkgs/tree/nixos-unstable/pkgs/development/tools/parsing/tree-sitter/grammars
  treesitter = pkgs.vimPlugins.nvim-treesitter.withPlugins (plugins: with plugins; [
    tree-sitter-bash
    tree-sitter-comment
    tree-sitter-fish
    tree-sitter-html
    tree-sitter-json
    tree-sitter-lua
    tree-sitter-make
    tree-sitter-markdown
    tree-sitter-nix
    tree-sitter-python
    tree-sitter-regex
    tree-sitter-rst
    tree-sitter-toml
    tree-sitter-vim
    tree-sitter-yaml
  ]);

  vimPlugins = with plugins; [
    beancount-nvim # https://github.com/polarmutex/beancount.nvim
    luasnip # https://github.com/l3mon4d3/luasnip
    cmp_luasnip # https://github.com/saadparwaiz1/cmp_luasnip
    cmp-nvim-lsp # https://github.com/hrsh7th/cmp-nvim-lsp
    cmp-buffer # https://github.com/hrsh7th/cmp-buffer
    {
      plugin = glow-nvim; # https://github.com/ellisonleao/glow.nvim
      config = ''
        let g:glow_binary_path = "${pkgs.glow}/bin"
      '';
    }
    kommentary # https://github.com/b3nj5m1n/kommentary
    lazygit-nvim # https://github.com/kdheepak/lazygit.nvim
    lsp-colors-nvim # https://github.com/folke/lsp-colors.nvim
    {
      plugin = neoformat; # https://github.com/sbdchd/neoformat
      config = ''
        augroup fmt
          autocmd!
          autocmd BufWritePre * undojoin | Neoformat
        augroup END
      '';
    }
    nord-nvim # https://github.com/shaunsingh/nord.nvim
    telescope-fzf-native-nvim # https://github.com/nvim-telescope/telescope-fzf-native.nvim
    vim-fugitive # https://github.com/tpope/vim-fugitive
    vim-nix # https://github.com/LnL7/vim-nix
    vim-surround # https://github.com/tpope/vim-surround
    {
      plugin = vim-test; # https://github.com/vim-test/vim-test
      config = ''
        let test#strategy = "neovim"
      '';
    }

  ];

  vimPluginsWithConfig = with pkgs.vimPlugins;
    map pluginWithConfig [
      nvim-lspconfig # https://github.com/neovim/nvim-lspconfig
      nvim-cmp # https://github.com/hrsh7th/nvim-cmp
      treesitter # https://github.com/nvim-treesitter/nvim-treesitter
      telescope-nvim # https://github.com/nvim-telescope/telescope.nvim
      which-key-nvim # https://github.com/folke/which-key.nvim
    ];
in
{
  xdg.configFile."nvim/lua".source = ./lua;

  programs.neovim = {
    enable = true;
    extraConfig = ''
      lua require('init')
    '';
    plugins = vimPluginsWithConfig ++ vimPlugins;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
    withNodeJs = true; # for coc.nvim
    withPython3 = true; # for plugins
    extraPackages = with pkgs; [
      black
      gcc
      neovim-remote
      nodePackages.prettier
      nodePackages.pyright
      nodePackages.vscode-langservers-extracted
      rnix-lsp
      tree-sitter
    ];

  };

  # which-keys keymaps
  # xdg.configFile."nvim/lua/keymaps.lua".source = ./keymaps.lua;
}
