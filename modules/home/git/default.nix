{ ... }:
let
  gitConfig = {
    core.editor = "vim";
    github.user = "jhh";

    # https://blog.gitbutler.com/how-git-core-devs-configure-git/
    column.ui = "auto";
    branch.sort = "-committerdate";
    tag.sort = "version:refname";
    init.defaultBranch = "main";
    diff = {
      algorithm = "histogram";
      colorMoved = "plain";
      mnemonicPrefix = true;
      renames = true;
    };
    push = {
      default = "simple";
      autoSetupRemote = true;
      followTags = true;
    };
    fetch = {
      prune = true;
      pruneTags = true;
      all = true;
    };
    rebase = {
      autosquash = true;
      interactive = true;
      updateRefs = true;
    };
    merge.conflictStyle = "zdiff3";
    pull.rebase = true;

    # diff and merge tools
    diff.tool = "nvimdiff";
    difftool.nvimdiff.cmd = ''nvim -d "$LOCAL" "$REMOTE"'';
    difftool.prompt = false;

    merge.tool = "nvimdiff";
    mergetool.nvimdiff.cmd = ''nvim -d "$LOCAL" "$REMOTE" "$MERGED" -c "$wincmd w" -c "wincmd J"'';
    mergetool.prompt = false;
    mergetool.keepBackup = false;
  };

in
{
  programs.diff-so-fancy.enable = true;
  programs.git.enable = true;
  programs.git.settings = {
    user.name = "Jeff Hutchison";
    user.email = "jeff@jeffhutchison.com";
    signing = {
      signByDefault = true;
      key = "26960A62CBEEC91D";
    };

    alias = {
      amend = "commit --amend -m";
      br = "branch";
      co = "checkout";
      st = "status";
      la = "!git config -l | grep alias | cut -c 7-";
      ls = ''log --pretty=format:"%C(yellow)%h%Cred%d %Creset%s%Cblue [%cn]" --all --decorate --oneline --graph'';
      ll = ''log --pretty=format:"%C(yellow)%h%Cred%d %Creset%s%Cblue [%cn]" --decorate --numstat'';
      lg = "log --graph --abbrev-commit --decorate --format=format:'%C(blue)%h%C(reset) - %C(green)(%ar)%C(reset) %s %C(italic)- %an%C(reset)%C(magenta bold)%d%C(reset)' --all";

      cm = "commit -m";
      ca = "commit -am";
      dc = "diff --cached";
    };
  }
  // gitConfig;

  programs.git.ignores = import ./ignore.nix;
}
