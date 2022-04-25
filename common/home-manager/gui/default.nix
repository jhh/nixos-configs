{ config, lib, pkgs, ... }:

{
  imports = [
    ./alacritty.nix
  ];

  config = lib.mkIf config.j3ff.gui {

    xdg.enable = true;

    #---------------------------------------------------------------------
    # Packages
    #---------------------------------------------------------------------

    # Packages I always want installed. Most packages I install using
    # per-project flakes sourced with direnv and nix-shell, so this is
    # not a huge list.
    home.packages = with pkgs; [
      rofi
      virt-manager
      virt-viewer
      watch
      zathura
    ];

    #---------------------------------------------------------------------
    # Env vars and dotfiles
    #---------------------------------------------------------------------

    home.sessionVariables = {
      EDITOR = "nvim";
      PAGER = "less -FirSwX";
      MANPAGER = "less -FirSwX";
    };

    home.file.".inputrc".source = ./inputrc;

    xdg.configFile."i3/config".text = builtins.readFile ./i3;
    xdg.configFile."rofi/config.rasi".text = builtins.readFile ./rofi;

    #---------------------------------------------------------------------
    # Programs
    #---------------------------------------------------------------------

    programs.kitty = {
      enable = true;
      extraConfig = builtins.readFile ./kitty;
    };

    programs.i3status = {
      enable = true;

      general = {
        colors = true;
        color_good = "#A3BE8C";
        color_bad = "#BF616A";
        color_degraded = "#EBCB8B";
      };

      modules = {
        ipv6.enable = false;
        "wireless _first_".enable = false;
        "battery all".enable = false;
      };
    };

    xresources.extraConfig = builtins.readFile ./Xresources;

    # Make cursor not tiny on HiDPI screens
    xsession.pointerCursor = {
      name = "Vanilla-DMZ";
      package = pkgs.vanilla-dmz;
      size = 128;
    };
  };
}