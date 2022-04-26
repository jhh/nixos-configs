{ config, pkgs, ... }:

{
  homebrew.enable = true;
  homebrew.casks = [
    "visual-studio-code"
  ];
}
