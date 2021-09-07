{ config, pkgs, ... }:
let
  pluginWithConfig = plugin: {
    plugin = plugin;
    config = ''
      lua require 'j3ff.${plugin.pname}'
    '';
  };

  vimPlugins = with pkgs.vimPlugins; [
    glow-nvim
    gruvbox-nvim
    lazygit-nvim
    vim-fish
    vim-fugitive
    vim-go
    vim-nix
    vim-surround
    kommentary
  ];

  vimPluginsWithConfig = with pkgs.vimPlugins;
    map pluginWithConfig [ nvim-treesitter telescope-nvim which-key-nvim ];

  # vimConfig = builtins.readFile ./config.vim;

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
    extraPackages = with pkgs; [ gcc neovim-remote tree-sitter ];

  };

  # which-keys keymaps
  # xdg.configFile."nvim/lua/keymaps.lua".source = ./keymaps.lua;
}
