{ config, lib, pkgs, ... }:

let
  gitConfig = lib.mkMerge [
    {
      core = {
        editor = "vim";
        pager = "diff-so-fancy | less --tabs=4 -RFX";
      };
      github = { user = "jhh"; };
      hub = { protocol = "ssh"; };
      init = { defaultBranch = "main"; };
    }
    (lib.mkIf pkgs.stdenv.isDarwin {
      diff = { tool = "Kaleidoscope"; };
      difftool.Kaleidoscope = {
        cmd = ''
          ksdiff --partial-changeset --relative-path "$MERGED" -- "$LOCAL" "$REMOTE"
        '';
      };
      difftool.prompt = false;
      merge = { tool = "Kaleidoscope"; };
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
      ls = ''
        log --pretty=format:"%C(yellow)%h%Cred%d %Creset%s%Cblue [%cn]" --decorate'';
      ll = ''
        log --pretty=format:"%C(yellow)%h%Cred%d %Creset%s%Cblue [%cn]" --decorate --numstat'';
      lg =
        "log --graph --abbrev-commit --decorate --format=format:'%C(blue)%h%C(reset) - %C(green)(%ar)%C(reset) %s %C(italic)- %an%C(reset)%C(magenta bold)%d%C(reset)' --all";

      cm = "commit -m";
      ca = "commit -am";
      dc = "diff --cached";
    };

    ignores = [ "*.direnv" "*.envrc" "*.jvmopts" ".nvimlog" "*.swp" ];
  };
}
