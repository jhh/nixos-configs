# common/users/default.nix

{ config, pkgs, ... }:

{
  imports = [
    ./jeff.nix
    ./media.nix
    ./root.nix
  ];
  users.mutableUsers = false;
}
