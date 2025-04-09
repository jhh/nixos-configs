# fzf.fish plugin ctrl-R keybind is overwritten by vanilla fzf, so rebind
bind \cr _fzf_search_history
set --export fzf_preview_dir_cmd eza --all --color=always --oneline

if not functions -q __direnv_export_eval; and command -sq direnv
    direnv hook fish | source
end

if set -q GHOSTTY_RESOURCES_DIR
    source "$GHOSTTY_RESOURCES_DIR/shell-integration/fish/vendor_conf.d/ghostty-shell-integration.fish"
end

set --erase MANPATH
set --export MANPAGER 'nvim +Man!'
