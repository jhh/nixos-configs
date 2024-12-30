{ pkgs, specialArgs, ... }:
{
  programs.neovim = {
    # package = specialArgs.inputs.neovim-nightly-overlay.packages.${pkgs.system}.default;
    enable = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
    defaultEditor = true;

    plugins = with pkgs.vimPlugins; [
      copilot-vim
      dash-vim
      formatter-nvim
      lazygit-nvim
      mini-nvim
      nvim-lspconfig
      nvim-treesitter.withAllGrammars
      nvim-web-devicons
      telescope-file-browser-nvim
      telescope-fzf-native-nvim
      telescope-nvim
      telescope-undo-nvim
      tokyonight-nvim
      which-key-nvim
    ];

    extraPackages = with pkgs; [
      basedpyright
      fd
      lua-language-server
      nil
      nixfmt-rfc-style
      ripgrep
      ruff
      stylua
    ];

    extraLuaConfig =
      let
        initLua = pkgs.concatText "init.lua" [
          ./init.lua
          ./formatter.lua
          ./lsp.lua
          ./telescope.lua
        ];
      in
      builtins.readFile initLua;
  };
}
