{ config, pkgs, ... }:

{
  homebrew = {
    enable = true;
    cleanup = "zap";

    # brews = [
    # ];

    casks = [
      "firefox"
      "visual-studio-code"
    ];

    masApps = {
      "1Password 7" = 1333542190;
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
