{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.j3ff.nvim;
in
{
  options.j3ff.nvim.enable = lib.mkEnableOption "Neovim";

  config = lib.mkIf cfg.enable {
    programs.neovim = {
      # package = specialArgs.inputs.neovim-nightly-overlay.packages.${pkgs.system}.default;
      enable = true;
      viAlias = true;
      vimAlias = true;
      vimdiffAlias = true;
      defaultEditor = true;

      plugins = with pkgs.vimPlugins; [
        dash-vim
        formatter-nvim
        lazygit-nvim
        mini-nvim
        nvim-lspconfig
        nvim-treesitter.withAllGrammars
        nvim-web-devicons
        oil-nvim
        tailwind-tools-nvim
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
        tailwindcss-language-server
      ];

      extraLuaConfig =
        let
          initLua = pkgs.concatText "init.lua" [
            ./fold.lua
            ./formatter.lua
            ./init.lua
            ./lsp.lua
            ./telescope.lua
          ];
        in
        builtins.readFile initLua;
    };
  };
}
