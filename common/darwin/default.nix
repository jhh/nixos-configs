# common/darwin/default.nix
{ ... }:
{
  imports = [
    ./homebrew.nix
    ./sudo-touch.nix
  ];
}
