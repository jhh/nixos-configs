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
    tree-sitter-comment
    tree-sitter-cpp
    tree-sitter-css
    tree-sitter-embedded-template
    tree-sitter-fish
    tree-sitter-go
    tree-sitter-html
    tree-sitter-java
    tree-sitter-javascript
    tree-sitter-json
    tree-sitter-lua
    tree-sitter-make
    tree-sitter-markdown
    tree-sitter-nix
    tree-sitter-python
    tree-sitter-regex
    tree-sitter-rst
    tree-sitter-toml
    tree-sitter-typescript
    tree-sitter-vim
    tree-sitter-yaml
  ]);

  vimPlugins = with plugins; [
    beancount-nvim # https://github.com/polarmutex/beancount.nvim
    luasnip # https://github.com/l3mon4d3/luasnip
    cmp_luasnip # https://github.com/saadparwaiz1/cmp_luasnip
    cmp-nvim-lsp # https://github.com/hrsh7th/cmp-nvim-lsp
    cmp-buffer # https://github.com/hrsh7th/cmp-buffer
    glow-nvim # https://github.com/ellisonleao/glow.nvim
    kommentary # https://github.com/b3nj5m1n/kommentary
    lazygit-nvim # https://github.com/kdheepak/lazygit.nvim
    lsp-colors-nvim # https://github.com/folke/lsp-colors.nvim
    nord-nvim # https://github.com/shaunsingh/nord.nvim
    telescope-fzf-native-nvim # https://github.com/nvim-telescope/telescope-fzf-native.nvim
    vim-fugitive # https://github.com/tpope/vim-fugitive
    vim-go # https://github.com/fatih/vim-go
    vim-nix # https://github.com/LnL7/vim-nix
    vim-surround # https://github.com/tpope/vim-surround
    vim-test # https://github.com/vim-test/vim-test
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
      let g:glow_binary_path = "${pkgs.glow}/bin"
      let test#strategy = "neovim"
    '';
    plugins = vimPluginsWithConfig ++ vimPlugins;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
    withNodeJs = true; # for coc.nvim
    withPython3 = true; # for plugins
    extraPackages = with pkgs; [
      gcc
      neovim-remote
      nodePackages.pyright
      nodePackages.vscode-langservers-extracted
      rnix-lsp
      tree-sitter
    ];

  };

  # which-keys keymaps
  # xdg.configFile."nvim/lua/keymaps.lua".source = ./keymaps.lua;
}
