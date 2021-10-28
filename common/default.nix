# common/default.nix
{ ... }:

{
  imports = [
    ./hosts.nix
    ./users
    ./services
  ];
}
