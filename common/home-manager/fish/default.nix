{
  pkgs,
  ...
}:
let
  defaultPlugins = [
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
    };

    functions = {
      "show-nix-diffs" = {
        body = ''
          nix store diff-closures (ls -d /nix/var/nix/profiles/* | tail -n 2 | cut -d ' ' -f 1)
        '';
      };
    };

    plugins = defaultPlugins;

    interactiveShellInit =
      let
        initFish = builtins.concatStringsSep "\n" [
          (builtins.readFile ./config.fish)
        ];
      in
      initFish;
  };

  home.sessionVariables = {
    EZA_CONFIG_DIR = ".config/eza";
  };

  home.file = {
    ".config/fish/themes/Catppuccin Mocha.theme" = {
      source = ./catppuccin_mocha.theme;
    };

    ".config/eza/theme.yml" = {
      source = ./catppuccin_eza.yml;
    };

    "Library/Application Support/com.mitchellh.ghostty/config" = {
      text = ''
      theme = catppuccin-mocha
      font-family = "MonoLisa Regular"
      font-family-bold = "MonoLisa Bold"
      font-family-italic = "MonoLisa Regular Italic"
      font-family-bold-italic = "MonoLisa Bold Italic"
      font-feature = "calt"
      '';
    };
  };
}
