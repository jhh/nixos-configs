# common/services/default.nix
{ ... }:
{
  imports = [
    ./dns.nix
    ./postfix.nix
    ./tailscale.nix
    ./ups.nix
    ./zrepl
  ];
}
