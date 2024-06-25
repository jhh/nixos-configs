# common/users/default.nix

{ config, pkgs, ... }:

{
  imports = [
    ./jeff.nix
    ./media.nix
    ./paperless.nix
    ./root.nix
  ];
  users.mutableUsers = false;
}
