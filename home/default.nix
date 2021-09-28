{ config, lib, pkgs, ... }:
let

  defaultPackages = with pkgs; [
    asciinema # record the terminal
    bottom # alternative to htop & ytop
    du-dust # more intuitive version of du in rust
    duf # disk usage/free utility
    fd # "find" for files
    fortune # print a random, hopefully interesting, adage
    fzf #  command-line fuzzy finder
    glow # markdown previewer
    htop # interactive process viewer
    httpie # command-line HTTP client
    jq # JSON parsing cli
    lazygit # simple terminal UI for git commands
    lorri # build changes in shell.nix automatically
    manix # documentation searcher for nix
    neofetch # command-line system information
    niv # dependency management for Nix projects
    nixpkgs-fmt # formatter for Nix code
    nyancat # the famous rainbow cat!
    prettyping # a nicer ping
    ripgrep # search in files
    tealdeer # fast version of tldr
  ];

  gitPkgs = with pkgs.gitAndTools; [
    diff-so-fancy # git diff with colors
    gh # GitHub CLI
    git-crypt # git files encryption
    hub # github command-line client
  ];

in
{
  imports = (import ./programs);

  home = {
    username = "jeff";
    homeDirectory = if pkgs.stdenv.isDarwin then "/Users/jeff" else "/home/jeff";

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

    gpg.enable = true;

    man = {
      enable = true;
      generateCaches = true;
    };

    nix-index = {
      enable = true;
      enableFishIntegration = pkgs.stdenv.isDarwin;
    };

    zoxide = {
      enable = true;
      enableFishIntegration = true;
    };

  };

  services = lib.mkIf pkgs.stdenv.isLinux {
    lorri.enable = true;
  };
}