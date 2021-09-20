# common/services/default.nix
{ ... }:
{
  imports = [
    ./dns.nix
    ./tailscale.nix
    ./ups.nix
    ./zrepl
  ];
}
