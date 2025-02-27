{ lib, pkgs, ... }:
let
  gitConfig = lib.mkMerge [
    {
      core.editor = "vim";
      github.user = "jhh";
    }
    {
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
    }
    (lib.mkIf pkgs.stdenv.isDarwin {
      diff = {
        tool = "Kaleidoscope";
      };
      difftool.Kaleidoscope = {
        cmd = ''
          ksdiff --partial-changeset --relative-path "$MERGED" -- "$LOCAL" "$REMOTE"
        '';
        trustExitCode = true;
      };
      difftool.prompt = false;

      merge = {
        tool = "Kaleidoscope";
      };
      mergetool.Kaleidoscope = {
        cmd = ''
          ksdiff --merge --output "$MERGED" --base "$BASE" -- "$LOCAL" --snapshot "$REMOTE" --snapshot
        '';
        trustExitCode = true;
      };
      mergetool.prompt = false;
    })
  ];

in
{
  programs.git = {
    enable = true;
    diff-so-fancy.enable = true;
    userName = "Jeff Hutchison";
    userEmail = "jeff@jeffhutchison.com";
    signing = {
      signByDefault = true;
      key = "26960A62CBEEC91D";
    };

    extraConfig = gitConfig;

    aliases = {
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

    ignores = import ./ignore.nix;
  };
}
