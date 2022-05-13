{ config, pkgs, ... }:

{
  homebrew = {
    enable = true;
    cleanup = "zap";

    # brews = [
    #   "terminal-notifier"
    # ];

    casks = [
      "1password"
      "alfred"
      "carbon-copy-cloner"
      "dash"
      "firefox"
      "iterm2"
      "jetbrains-toolbox"
      "kaleidoscope"
      "spotify"
      "tableplus"
      "thetimemachinemechanic"
      "visual-studio-code"
    ];

    masApps = {
      "Affinity Photo" = 824183456;
      "Infuse 7" = 1136220934;
      "Paprika Recipe Manager 3" = 1303222628;
      "Pcalc" = 403504866;
      "Reeder 5" = 1529448980;
      "Slack for Desktop" = 803453959;
      "Tailscale" = 1475387142;
      "Twitter" = 1482454543;
    };
  };
}
