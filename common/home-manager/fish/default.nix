{ flakes, config, lib, pkgs, ... }:
let
  defaultPlugins = [
    {
      name = "colored-man";
      src = flakes.fish-colored-man;
    }

    {
      name = "fzf-fish";
      src = pkgs.fishPlugins.fzf-fish.src;
    }
  ];

  darwinPlugins =
    if pkgs.stdenv.isDarwin then [
      {
        name = "foreign-env";
        src = pkgs.fishPlugins.foreign-env.src;
      }

      {
        name = "nix-env";
        src = flakes.fish-nix-env;
      }
    ] else [ ];

in
{
  programs.fish = {
    enable = true;

    shellAbbrs = {
      gcb = "git checkout -b";
      gcm = "git switch main";
      gmnff = "git merge --no-ff";
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

    functions = {
      "show-nix-diffs" = {
        body = ''
          nix store diff-closures (ls -d /nix/var/nix/profiles/* | tail -n 2 | cut -d ' ' -f 1)
        '';
      };
    };

    plugins = defaultPlugins ++ darwinPlugins;

    # fzf.fish plugin ctrl-R keybind is overwritten by vanilla fzf, so rebind
    interactiveShellInit = builtins.readFile ./interactiveShellInit.fish;

    # shellInit =
    #   lib.optionalString pkgs.stdenv.isDarwin ''
    #     fenv export NIX_PATH=\$HOME/.nix-defexpr/channels\''${NIX_PATH:+:}\$NIX_PATH
    #   '';
  };

  home.file = {
    ".config/fish/functions/fish_prompt.fish".source = ./fish_prompt.fish;
    ".config/fish/functions/fish_right_prompt.fish".source = ./fish_right_prompt.fish;
    ".config/fish/conf.d/iterm2.fish".source = ./iterm2_shell_integration.fish;
  };
}
