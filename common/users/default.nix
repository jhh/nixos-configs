# common/users/default.nix

{ flakes, config, pkgs, ... }:

{
  imports = [ ./jeff.nix ./root.nix ];
}
