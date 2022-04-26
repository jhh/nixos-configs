{ config, pkgs, ... }:

{
  homebrew = {
    enable = true;
    cleanup = "zap";

    casks = [
      "visual-studio-code"
    ];
  };
}
