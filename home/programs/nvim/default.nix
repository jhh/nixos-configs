{ config, pkgs, ... }:
let
  vimPlugins = with pkgs.vimPlugins; [
    kommentary
    {
      plugin = lazygit-nvim;
      config = ''
        if has('nvim') && executable('nvr')
          let $GIT_EDITOR = "nvr -cc split --remote-wait +'set bufhidden=wipe'"
        endif
      '';
    }
    {
      plugin = telescope-nvim;
      config = ''
        lua require("telescope").setup { }
      '';
    }
    lazygit-nvim
    vim-fish
    vim-fugitive
    vim-nix
    vim-surround
    {
      plugin = which-key-nvim;
      config = ''
        set timeoutlen=500
        lua require "which-key".setup { }
        lua require('keymaps')
      '';
    }
    {
      plugin = nvim-treesitter;
      config = ''
        lua <<EOF
        require "nvim-treesitter.configs".setup {
          ensure_installed = "maintained",
          highlight = { enable = true },
          incremental_selection = { enable = true },
          indent = { enable = true },
        }
        EOF
      '';
    }
  ];

  vimConfig = builtins.readFile ./config.vim;

in {
  programs.neovim = {
    enable = true;
    extraConfig = vimConfig;
    plugins = vimPlugins;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
    withNodeJs = true; # for coc.nvim
    withPython3 = true; # for plugins
    extraPackages = with pkgs; [ gcc neovim-remote tree-sitter ];

  };

  # which-keys keymaps
  xdg.configFile."nvim/lua/keymaps.lua".source = ./keymaps.lua;
}
