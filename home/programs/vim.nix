{ config, pkgs, ... }: {
  programs.vim = {
    enable = true;

    plugins = with pkgs.vimPlugins; [
      vim-commentary
      vim-fugitive
      vim-nix
      vim-sensible
    ];

    settings = {
      background = "dark";
      relativenumber = true;
    };
  };
}
