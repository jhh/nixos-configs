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
    ./ups.nix
    ./virtualization.nix
    ./zfs.nix
    ./zrepl.nix
  ];
}
