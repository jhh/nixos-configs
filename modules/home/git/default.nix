{ config, ... }:
let
  gitConfig = {
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
    user = {
      name = "Jeff Hutchison";
      email = "jeff@j3ff.io";
    };

    gitbutler.signCommits = true;
    gpg.ssh.allowedSignersFile = "${config.xdg.configHome}/git/allowed_signers";
  };

in
{
  programs.diff-so-fancy.enable = true;
  programs.git = {
    enable = true;
    settings = gitConfig;
    signing = {
      format = "ssh";
      key = "~/.ssh/id_ed25519.pub";
      signByDefault = true;
    };
    ignores = import ./ignore.nix;
  };

  xdg.configFile."git/allowed_signers" = {
    text = ''
      jeff@j3ff.io ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPqpWpNJzfzioGYyR9q4wLwPkBrnmc/Gdl6JsO+SUpel
    '';
  };
}
