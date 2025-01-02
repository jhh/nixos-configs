{
  lib,
  pkgs,
  ...
}:
let

  defaultPackages =
    with pkgs;
    [
      asciinema # record the terminal
      bottom # alternative to htop & ytop
      du-dust # more intuitive version of du in rust
      duf # disk usage/free utility
      fd # "find" for files
      fzf # command-line fuzzy finder
      glow # markdown previewer
      htop # interactive process viewer
      jq # JSON parsing cli
      lazygit # simple terminal UI for git commands
      neofetch # command-line system information
      nixpkgs-fmt # formatter for Nix code
      prettyping # a nicer ping
      ripgrep # search in files
      tealdeer # fast version of tldr
    ]
    ++ lib.optionals pkgs.stdenv.isDarwin [ cookiecutter nodejs ];

  gitPkgs = with pkgs.gitAndTools; [
    diff-so-fancy # git diff with colors
    gh # GitHub CLI
  ];

in
{
  imports = [
    ./bat
    ./fish
    ./git
    ./nvim
    ./sonos
    ./starship
  ];
  # ] ++ lib.optional pkgs.stdenv.isDarwin ./sonos;

  home = {
    username = "jeff";
    homeDirectory = if pkgs.stdenv.isDarwin then "/Users/jeff" else "/home/jeff";

    sessionVariables = {
      LANG = "en_US.UTF-8";
      LC_CTYPE = "en_US.UTF-8";
      LC_ALL = "en_US.UTF-8";
      MANWIDTH = 88;
    };

    sessionPath = lib.optionals pkgs.stdenv.isDarwin [ "/opt/homebrew/bin" "$HOME/.local/bin/" ];

    packages = defaultPackages ++ gitPkgs;
    stateVersion = "22.05";
  };

  programs = {
    home-manager.enable = true;

    bat.enable = true;

    direnv = {
      enable = true;
      nix-direnv = {
        enable = true;
      };
    };

    eza.enable = true;

    gpg = {
      enable = true;
      settings = {
        keyserver = "hkps://keys.openpgp.org";
      };
    };

    man = lib.mkIf pkgs.stdenv.isDarwin {
      enable = true;
      generateCaches = true;
    };

    nix-index = {
      enable = pkgs.stdenv.isLinux;
      enableFishIntegration = pkgs.stdenv.isDarwin;
    };

    zoxide = {
      enable = true;
      enableFishIntegration = true;
    };

  };

  services = {
    syncthing = {
      enable = false;
      extraOptions = lib.mkIf pkgs.stdenv.isLinux [ "--gui-address=0.0.0.0:8384" ];
    };
  };
}
