{ config, lib, pkgs, ... }:
let
  tmuxConf = ''
    bind-key r source-file ~/.config/tmux/tmux.conf \; display-message "tmux.conf reloaded"
    set -g status-left-length 50
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
