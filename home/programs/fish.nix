{ config, lib, pkgs, ... }:
let
  defaultPlugins = [
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
  ];

    extraPlugins = if pkgs.stdenv.isDarwin then [

      {
        name="foreign-env";
        src = pkgs.fetchFromGitHub {
          owner = "oh-my-fish";
          repo = "plugin-foreign-env";
          rev = "dddd9213272a0ab848d474d0cbde12ad034e65bc";
          sha256 = "00xqlyl3lffc5l0viin1nyp819wf81fncqyz87jx8ljjdhilmgbs";
        };
      }
      {
         name = "nix-env";
         src =   pkgs.fetchFromGitHub {
           owner = "lilyball";
           repo = "nix-env.fish";
           rev = "00c6cc762427efe08ac0bd0d1b1d12048d3ca727";
           sha256 = "1hrl22dd0aaszdanhvddvqz3aq40jp9zi2zn0v1hjnf7fx4bgpma";
           fetchSubmodules = true;
        };
      }
    ] else [];

in {
  programs.fish = {
    enable = true;

    shellAbbrs = {
      gcb = "git checkout -b";
      gcm = "git switch main";
      gst = "git status";
    };

    shellAliases = {
      dc = "docker-compose";
      dps = "docker-compose ps";
      dcd = "docker-compose down --remove-orphans";
      drm = "docker images -a -q | xargs docker rmi -f";
      du = "dust";
      git = "hub";
      ping = "prettyping";
    };

    plugins = defaultPlugins ++ extraPlugins;

    # fzf.fish plugin ctrl-R keybind is overwritten by vanilla fzf, so rebind
    interactiveShellInit = "bind \\cr _fzf_search_history";

    shellInit = if pkgs.stdenv.isDarwin then
      ''
        fenv export NIX_PATH=\$HOME/.nix-defexpr/channels\''${NIX_PATH:+:}\$NIX_PATH
      ''
      else "";
  };
}
