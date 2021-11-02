# common/default.nix
{ ... }:

{
  imports = [
    ./home.nix # home-manager setup<F2>
    ./hosts.nix # common to all hosts
    ./users.nix # default users
    ./services # service modules
  ];
}
