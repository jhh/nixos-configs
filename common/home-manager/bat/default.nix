{ pkgs, ... }:
{
  programs.bat = {
    enable = true;
    config = {
      theme = "Catppuccin Mocha";
    };

    extraPackages = with pkgs.bat-extras; [
      batman
    ];

    themes = {
      "Tokyo Night" = {
        src = ./tokyonight_night.tmTheme;
      };

      "Catppuccin Mocha" = {
        src = ./catppuccin_mocha.tmTheme;
      };
    };

    syntaxes = {
      "ghostty" = {
        src = ./ghostty.sublime-syntax;
      };
    };
  };
}
