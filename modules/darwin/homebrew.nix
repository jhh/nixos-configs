{ ... }:

{
  homebrew = {
    enable = true;
    onActivation = {
      cleanup = "zap";
      upgrade = true;
      autoUpdate = true;
    };

    taps = [
      "d12frosted/emacs-plus"
    ];

    brews = [
      "clojure"
      "emacs-plus"
      "neovim"
      "uv"
    ];

    casks = [
      "1password"
      "1password-cli"
      "calibre"
      "carbon-copy-cloner"
      "dash"
      "discord"
      "firefox"
      "iterm2"
      # "jetbrains-toolbox"
      "omnigraffle"
      "postgres-unofficial"
      "postico"
      "qlmarkdown"
      "slack"
      "spotify"
      "tableplus"
      "thetimemachinemechanic"
      "transmit"
      "visual-studio-code"
      "zotero"
    ];

    masApps = {
      "Icon Slate" = 439697913;
      "Infuse 7" = 1136220934;
      "Paprika Recipe Manager 3" = 1303222628;
      "Pcalc" = 403504866;
      "Reeder 5" = 1529448980;
      "Tailscale" = 1475387142;
    };
  };
}
