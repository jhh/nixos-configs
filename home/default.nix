{ config, pkgs, ... }:
let

  defaultPackages = with pkgs; [
    asciinema # record the terminal
    bottom # alternative to htop & ytop
    du-dust # more intuitive version of du in rust
    duf # disk usage/free utility
    fd # "find" for files
    fortune # print a random, hopefully interesting, adage
    htop # interactive process viewer
    lazygit # simple terminal UI for git commands
    manix # documentation searcher for nix
    neofetch # command-line system information
    nixfmt # formatter for Nix code
    nyancat # the famous rainbow cat!
    prettyping # a nicer ping
    ripgrep # search in files
  ];

  gitPkgs = with pkgs.gitAndTools; [
    diff-so-fancy # git diff with colors
    gh # GitHub CLI
    git-crypt # git files encryption
    hub # github command-line client
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

    zoxide = {
      enable = true;
      enableFishIntegration = true;
    };

  };

  services.lorri.enable = true;
}
