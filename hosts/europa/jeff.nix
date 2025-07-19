{ pkgs, ... }:
{
  home-manager.users.jeff = {
    services.vscode-server.enable = false;

    home.packages = with pkgs; [
      ast-grep
      btop
      chromium
      curl
      fastfetch
      fd
      gcc
      ghostty
      gnumake
      hyprpaper
      hyprpolkitagent
      imagemagick
      mako
      markdownlint-cli2
      marksman
      mermaid-cli
      nodejs
      ripgrep
      spotify
      stow
      sqlite
      texliveSmall
      unzip
      waybar
      wget
      wl-clipboard
      wl-clip-persist
    ];
  };
}
