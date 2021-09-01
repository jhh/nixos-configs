{ config, pkgs, ... }:

let
  gitConfig = {
    core = {
      editor = "vim";
      pager = "diff-so-fancy | less --tabs=4 -RFX";
    };
    init.defaultBranch = "main";
  };
in {
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

    ignores = [ "*.direnv" "*.envrc" "*.jvmopts" "*.swp" ];
  };
}
