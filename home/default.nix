{ config, pkgs, ... }:
let

  defaultPackages = with pkgs; [
    asciinema # record the terminal
    bottom # alternative to htop & ytop
    duf # disk usage/free utility
    fd # "find" for files
    fortune # print a random, hopefully interesting, adage
    gitAndTools.gh # GitHub CLI
    htop # interactive process viewer
    manix # documentation searcher for nix
    ncdu # NCurses Disk Usage
    neofetch # command-line system information
    nixfmt # formatter for Nix code
    nyancat # the famous rainbow cat!
    prettyping # a nicer ping
  ];

  gitPkgs = with pkgs.gitAndTools; [
    diff-so-fancy # git diff with colors
    git-crypt # git files encryption
    hub # github command-line client
    tig # diff and commit view
  ];

in {
  imports = (import ./programs);

  home = {
    username = "jeff";
    homeDirectory = "/home/jeff";

    sessionVariables = {
      EDITOR = "vim";
      MANWIDTH = 100;
    };

    packages = defaultPackages ++ gitPkgs;
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;


  programs.bat.enable = true;

  programs.direnv = {
    enable = true;
    enableFishIntegration = true;
    nix-direnv.enable = true;
  };

  programs.exa = {
    enable = true;
    enableAliases = true;
  };

  programs.fzf = {
    enable = true;
    enableFishIntegration = false;
  };

  programs.gpg.enable = true;

  #programs.gh.enable = true;

  programs.man = {
    enable = true;
    generateCaches = true;
  };

  programs.starship = {
    enable = true;
    enableFishIntegration = true;
  };

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

  services.lorri.enable = true;
}
