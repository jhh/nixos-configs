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

  treesitter = pkgs.vimPlugins.nvim-treesitter.withPlugins (
    plugins: with plugins; [
      tree-sitter-nix
      tree-sitter-python
    ]
  );

  vimPlugins = with plugins; [
    beancount-nvim # https://github.com/polarmutex/beancount.nvim
    # cmp-nvim-lsp # https://github.com/hrsh7th/cmp-nvim-lsp
    # cmp-buffer # https://github.com/hrsh7th/cmp-buffer
    glow-nvim # https://github.com/ellisonleao/glow.nvim
    kommentary # https://github.com/b3nj5m1n/kommentary
    nord-nvim # https://github.com/shaunsingh/nord.nvim
    vim-fugitive # https://github.com/tpope/vim-fugitive
    vim-go # https://github.com/fatih/vim-go
    vim-nix # https://github.com/LnL7/vim-nix
    vim-surround # https://github.com/tpope/vim-surround
  ];

  vimPluginsWithConfig = with pkgs.vimPlugins;
    map pluginWithConfig [
      # nvim-cmp # https://github.com/hrsh7th/nvim-cmp
      nvim-lspconfig # https://github.com/neovim/nvim-lspconfig
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
    '';
    plugins = vimPlugins ++ vimPluginsWithConfig;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
    withNodeJs = true; # for coc.nvim
    withPython3 = true; # for plugins
    extraPackages = with pkgs; [ gcc neovim-remote nodePackages.pyright tree-sitter ];

  };

  # which-keys keymaps
  # xdg.configFile."nvim/lua/keymaps.lua".source = ./keymaps.lua;
}
