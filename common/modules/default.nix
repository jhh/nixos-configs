# common/services/default.nix
{ ... }:
{
  imports = [
    ./dns.nix
    ./man.nix
    ./postfix.nix
    ./prometheus.nix
    ./smartd.nix
    ./tailscale.nix
    ./upgrade-diff.nix
    ./ups.nix
    ./virtualization.nix
    ./watchtower
    ./zfs.nix
    ./zrepl.nix
  ];
}
