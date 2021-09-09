{ config, lib, pkgs, ... }:
let
  tmuxConf = ''
    bind-key r source-file ~/.config/tmux/tmux.conf \; display-message "tmux.conf reloaded"
    set -g status-left-length 50
    bind-key j choose-tree -swZ
    bind C-j display-popup -E "\
      tmux list-sessions -F '#{?session_attached,,#{session_name}}' |\
      sed '/^$/d' |\
      fzf --reverse --header jump-to-session --preview 'tmux capture-pane -pt {}'  |\
      xargs tmux switch-client -t"
  '';
in {
  programs.tmux = {
    enable = true;
    shortcut = "s";
    baseIndex = 1;
    extraConfig = tmuxConf;
    plugins = with pkgs.tmuxPlugins; [
      nord # https://github.com/arcticicestudio/nord-tmux
      pain-control # https://github.com/tmux-plugins/tmux-pain-control
      sensible # https://github.com/tmux-plugins/tmux-sensible
    ];
  };
}
