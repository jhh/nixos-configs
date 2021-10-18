{ config, lib, pkgs, ... }:
let
  sources = import ../../../nix/sources.nix;

  defaultPlugins = [
    {
      name = "colored-man";
      src = sources.fish-colored-man;
    }

    {
      name = "fzf-fish";
      src = sources.fish-fzf;
    }
  ];

  darwinPlugins =
    if pkgs.stdenv.isDarwin then [
      {
        name = "foreign-env";
        src = sources.fish-plugin-foreign-env;
      }
      {
        name = "nix-env";
        src = sources.fish-nix-env;
      }
    ] else [ ];

in
{
  programs.fish = {
    enable = true;

    shellAbbrs = {
      gcb = "git checkout -b";
      gcm = "git switch main";
      gmnff = "git merge --no-ff";
      gst = "git status";
    };

    shellAliases = {
      dc = "docker-compose";
      dps = "docker-compose ps";
      dcd = "docker-compose down --remove-orphans";
      drm = "docker images -a -q | xargs docker rmi -f";
      du = "dust";
      git = "hub";
      ping = "prettyping";
    };

    plugins = defaultPlugins ++ darwinPlugins;

    # fzf.fish plugin ctrl-R keybind is overwritten by vanilla fzf, so rebind
    interactiveShellInit = ''
      source $HOME/.config/iterm2/iterm2_shell_integration.fish
      bind \cr _fzf_search_history
    '';

    shellInit =
      if pkgs.stdenv.isDarwin then ''
        fenv export NIX_PATH=\$HOME/.nix-defexpr/channels\''${NIX_PATH:+:}\$NIX_PATH
      '' else
        "";
  };
  xdg.configFile."iterm2/iterm2_shell_integration.fish".source =
    ./iterm2_shell_integration.fish;
}
