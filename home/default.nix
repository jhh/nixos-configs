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

  programs = {
    home-manager.enable = true;

    bat.enable = true;

    direnv = {
      enable = true;
      enableFishIntegration = true;
      nix-direnv.enable = true;
    };

    exa = {
      enable = true;
      enableAliases = true;
    };

    fzf = {
      enable = true;
      enableFishIntegration = false;
    };

    gpg.enable = true;

    man = {
      enable = true;
      generateCaches = true;
    };

    starship = {
      enable = true;
      enableFishIntegration = true;
    };
  };

  services.lorri.enable = true;
}
