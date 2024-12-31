{ pkgs, ... }:
{
  programs.bat = {
    enable = true;
    config = {
      theme = "Tokyo Night";
    };

    extraPackages = with pkgs.bat-extras; [
      batman
    ];

    themes = {
      "Tokyo Night" = {
        src = ./tokyonight_night.tmTheme;
      };
    };

    syntaxes = {
      "ghostty" = {
        src = ./ghostty.sublime-syntax;
      };
    };
  };
}
