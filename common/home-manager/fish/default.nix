{ config, lib, pkgs, ... }:
let
  defaultPlugins = [
    {
      name = "colored-man-pages";
      src = pkgs.fishPlugins.colored-man-pages.src;
    }

    {
      name = "fzf-fish";
      src = pkgs.fishPlugins.fzf-fish.src;
    }
  ];

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
      # git = "hub";
    };

    functions = {
      "show-nix-diffs" = {
        body = ''
          nix store diff-closures (ls -d /nix/var/nix/profiles/* | tail -n 2 | cut -d ' ' -f 1)
        '';
      };
    };

    plugins = defaultPlugins;

    interactiveShellInit = ''
      ### Add nix binary paths to the PATH
      # Perhaps someday will be fixed in nix or nix-darwin itself
      if test (uname) = Darwin
        fish_add_path --prepend --path --move --global "$HOME/.nix-profile/bin" /nix/var/nix/profiles/default/bin /run/current-system/sw/bin
      end

      # fzf.fish plugin ctrl-R keybind is overwritten by vanilla fzf, so rebind
      bind \cr _fzf_search_history
      set --export fzf_preview_dir_cmd eza --all --color=always --oneline

      if not functions -q __direnv_export_eval; and command -sq direnv
          direnv hook fish | source
      end

      set --local WPI_YEAR 2024
      if test -d ~/wpilib/$WPI_YEAR
          abbr --add --global pathweaver ~/wpilib/$WPI_YEAR/tools/PathWeaver.py
          abbr --add --global outlineviewer ~/wpilib/$WPI_YEAR/tools/OutlineViewer.py
          set --export JAVA_HOME ~/wpilib/$WPI_YEAR/jdk
          fish_add_path $JAVA_HOME/bin
      end

      if test -x /opt/homebrew/bin/brew
          eval (/opt/homebrew/bin/brew shellenv)
      end

      if test -x ~/.ghcup/bin
          fish_add_path ~/.ghcup/bin
      end

    '';
  };

  home.file = {
    ".config/fish/functions/fish_prompt.fish".source = ./fish_prompt.fish;
    ".config/fish/functions/fish_right_prompt.fish".source = ./fish_right_prompt.fish;
    ".config/fish/conf.d/iterm2.fish".source = ./iterm2_shell_integration.fish;
  };
}
