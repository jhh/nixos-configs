{ config, pkgs, ... }:

{
  home.sessionVariables = {
    EDITOR = "vim";
    MANWIDTH = 100;
  };

  home.packages = with pkgs; [
    fd
    fortune
    gitAndTools.gh
    htop
    ncdu
    nixfmt
    prettyping
  ];

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  programs.fish = {
    enable = true;
    plugins = [
      {
        name = "colored-man";
        src = pkgs.fetchFromGitHub {
          owner = "decors";
          repo = "fish-colored-man";
          rev = "1ad8fff696d48c8bf173aa98f9dff39d7916de0e";
          sha256 = "0l32a5bq3zqndl4ksy5iv988z2nv56a91244gh8mnrjv45wpi1ms";
          fetchSubmodules = true;
        };
      }

      {
        name = "fzf";
        src = pkgs.fetchFromGitHub {
          owner = "PatrickF1";
          repo = "fzf.fish";
          rev = "176c8465b0fad2d5c30aacafff6eb5accb7e3826";
          sha256 = "16mdfyznxjhv7x561srl559misn37a35d2q9fspxa7qg1d0sc3x9";
          fetchSubmodules = true;
        };
      }

      {
        name = "z";
        src = pkgs.fetchFromGitHub {
          owner = "jethrokuan";
          repo = "z";
          rev = "45a9ff6d0932b0e9835cbeb60b9794ba706eef10";
          sha256 = "1kjyl4gx26q8175wcizvsm0jwhppd00rixdcr1p7gifw6s308sd5";
          fetchSubmodules = true;
        };
      }
    ];

    shellAbbrs = {
      gst = "git status";
    };

    shellAliases = {
      dc = "docker-compose";
      dps = "docker-compose ps";
      dcd = "docker-compose down --remove-orphans";
      drm = "docker images -a -q | xargs docker rmi -f";
      du = "ncdu --color dark -rr -x";
      ping = "prettyping";
    };
  };

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

  programs.git = {
    enable = true;
    userName = "Jeff Hutchison";
    userEmail = "jeff@jeffhutchison.com";
    signing = {
      signByDefault = true;
      key = "26960A62CBEEC91D";
    };
  };

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
