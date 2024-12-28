{
  config,
  lib,
  pkgs,
  ...
}:
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
      gbd = "git branch -d";
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

      if test -x /opt/homebrew/bin/brew
          eval (/opt/homebrew/bin/brew shellenv)
      end

          # TokyoNight Color Palette
      set -l foreground c0caf5
      set -l selection 283457
      set -l comment 565f89
      set -l red f7768e
      set -l orange ff9e64
      set -l yellow e0af68
      set -l green 9ece6a
      set -l purple 9d7cd8
      set -l cyan 7dcfff
      set -l pink bb9af7

      # Syntax Highlighting Colors
      set -g fish_color_normal $foreground
      set -g fish_color_command $cyan
      set -g fish_color_keyword $pink
      set -g fish_color_quote $yellow
      set -g fish_color_redirection $foreground
      set -g fish_color_end $orange
      set -g fish_color_option $pink
      set -g fish_color_error $red
      set -g fish_color_param $purple
      set -g fish_color_comment $comment
      set -g fish_color_selection --background=$selection
      set -g fish_color_search_match --background=$selection
      set -g fish_color_operator $green
      set -g fish_color_escape $pink
      set -g fish_color_autosuggestion $comment

      # Completion Pager Colors
      set -g fish_pager_color_progress $comment
      set -g fish_pager_color_prefix $cyan
      set -g fish_pager_color_completion $foreground
      set -g fish_pager_color_description $comment
      set -g fish_pager_color_selected_background --background=$selection
    '';
  };

  home.file = {
    ".config/fish/functions/fish_prompt.fish".source = ./fish_prompt.fish;
    ".config/fish/functions/fish_right_prompt.fish".source = ./fish_right_prompt.fish;
    ".config/fish/conf.d/iterm2.fish".source = ./iterm2_shell_integration.fish;
  };
}
