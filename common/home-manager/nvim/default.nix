{ config, lib, pkgs, specialArgs,  ... }: {
  programs.neovim = {
    package = specialArgs.inputs.neovim-nightly-overlay.packages.${pkgs.system}.default;
    enable = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
    defaultEditor = true;

    plugins = with pkgs.vimPlugins; [
      lazygit-nvim
      mini-nvim
      nvim-treesitter.withAllGrammars
      nvim-web-devicons
      telescope-file-browser-nvim
      telescope-fzf-native-nvim
      telescope-nvim
      tokyonight-nvim
      which-key-nvim
    ];

    extraPackages = with pkgs; [
      fd
      ripgrep
    ];

    extraLuaConfig = builtins.readFile ./config.lua;
  };
}
