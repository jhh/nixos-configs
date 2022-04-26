{ config, pkgs, ... }:

{
  homebrew = {
    enable = true;
    cleanup = "zap";

    brews = [
      "mas"
    ];

    casks = [
      "visual-studio-code"
    ];

    masApps = [ ];
  };
}
