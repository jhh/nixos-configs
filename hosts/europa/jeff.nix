{ pkgs, ... }:
{
  home-manager.users.jeff = {
    services.vscode-server.enable = false;

    home.packages = with pkgs; [
      btop
      chromium
      curl
      fastfetch
      fd
      ghostty
      gnumake
      hyprpaper
      hyprpolkitagent
      mako
      ripgrep
      spotify
      stow
      unzip
      waybar
      wget
      wl-clipboard
      wl-clip-persist
    ];
  };
}
