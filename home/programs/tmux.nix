{ config, lib, pkgs, ... }:
let
  tmuxConf = ''
    bind-key r source-file ~/.config/tmux/tmux.conf \; display-message "tmux.conf reloaded"
    set -g status-left-length 50
    bind-key f choose-tree -swZ
    bind C-f display-popup -E "\
      tmux list-sessions -F '#{?session_attached,,#{session_name}}' |\
      sed '/^$/d' |\
      fzf --reverse --header jump-to-session --preview 'tmux capture-pane -pt {}'  |\
      xargs tmux switch-client -t"
    set-option -sa terminal-overrides ',xterm-256color:RGB'
  '';
in
{
  programs.tmux = {
    enable = true;
    baseIndex = 1;
    extraConfig = tmuxConf;
    keyMode = "vi";
    shortcut = "g";
    plugins = with pkgs.tmuxPlugins; [
      nord # https://github.com/arcticicestudio/nord-tmux
      pain-control # https://github.com/tmux-plugins/tmux-pain-control
      sensible # https://github.com/tmux-plugins/tmux-sensible
    ];

    tmuxp.enable = true;

  };

  xdg.configFile."tmuxp/home.json".text = lib.generators.toJSON { } {
    session_name = "home";
    windows = [
      {
        window_name = "root";
        panes = [ "sudo -i" ];
      }
      {
        window_name = "home";
        focus = true;
        panes = [ "pane" ];
        start_directory = "\${HOME}";
      }
    ];
  };

  xdg.configFile."tmuxp/deadeye.json".text = lib.generators.toJSON { } {
    session_name = "deadeye";
    windows = [
      {
        window_name = "deadeye";
        focus = true;
        start_directory = "\${HOME}/code/strykeforce/deadeye";
        panes = [ "pane" ];
      }
      {
        window_name = "daemon";
        start_directory = "\${HOME}/code/strykeforce/deadeye/daemon";
        panes = [
          { focus = true; }
          { shell_command = [ "cd build" "./src/deadeyed" ]; }
        ];
      }
      {
        window_name = "admin";
        start_directory = "\${HOME}/code/strykeforce/deadeye/admin";
        panes = [
          { focus = true; }
          { shell_command = "poetry run python -m deadeye.scripts.server"; }
        ];
      }
      {
        window_name = "web";
        start_directory = "\${HOME}/code/strykeforce/deadeye/web";
        panes = [
          { focus = true; }
          { shell_command = "npm start"; }
        ];
      }
    ];
  };
}
