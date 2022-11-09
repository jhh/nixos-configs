# common/users/default.nix

{ flakes, config, pkgs, ... }:

{
  imports = [
    ./jeff.nix
    ./media.nix
    ./root.nix
  ];
}
