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
      "l." = "ls -a";
      "ll." = "ls -al";
    };

    shellAliases = {
      dc = "docker-compose";
      dps = "docker-compose ps";
      dcd = "docker-compose down --remove-orphans";
      drm = "docker images -a -q | xargs docker rmi -f";
      du = "dust";
      ping = "prettyping";
      git = "hub";
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
    # interactiveShellInit = builtins.readFile ./interactiveShellInit.fish;
    interactiveShellInit = ''
      bind \cr _fzf_search_history

      if not functions -q __direnv_export_eval; and command -sq direnv
          direnv hook fish | source
      end

      set --local WPI_YEAR 2022
      if test -d ~/wpilib/$WPI_YEAR
          abbr --add --global pathweaver ~/wpilib/$WPI_YEAR/tools/PathWeaver.py
          abbr --add --global outlineviewer ~/wpilib/$WPI_YEAR/tools/OutlineViewer.py
          set --export JAVA_HOME ~/wpilib/$WPI_YEAR/jdk
          fish_add_path $JAVA_HOME/bin
      end

      if test -x /opt/homebrew/bin/brew
          eval (/opt/homebrew/bin/brew shellenv)
      end
    '';

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
