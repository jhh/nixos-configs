{ config, lib, pkgs, ... }:
{
  imports = [
    ./fish
    ./git.nix
    ./nvim
    ./starship.nix
    ./tmux.nix
  ];
}
