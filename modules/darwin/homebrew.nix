{ ... }:

{
  homebrew = {
    enable = true;
    onActivation = {
      cleanup = "zap";
      upgrade = true;
      autoUpdate = true;
    };

    brews = [
      "uv"
      "neovim"
    ];

    casks = [
      "1password"
      "carbon-copy-cloner"
      "dash"
      "discord"
      "docker"
      "firefox"
      "iterm2"
      "jetbrains-toolbox"
      "kaleidoscope"
      "omnigraffle"
      "postgres-unofficial"
      "postico"
      "spotify"
      "tableplus"
      "thetimemachinemechanic"
      "transmit"
      "visual-studio-code"
    ];

    masApps = {
      "Icon Slate" = 439697913;
      "Infuse 7" = 1136220934;
      "Paprika Recipe Manager 3" = 1303222628;
      "Pcalc" = 403504866;
      "Reeder 5" = 1529448980;
      "Slack for Desktop" = 803453959;
      "Tailscale" = 1475387142;
    };
  };
}
