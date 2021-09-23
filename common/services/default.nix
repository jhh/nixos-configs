# common/services/default.nix
{ ... }:
{
  imports = [
    ./dns.nix
    ./postfix.nix
    ./smartd.nix
    ./tailscale.nix
    ./ups.nix
    ./zfs.nix
    ./zrepl
  ];
}
