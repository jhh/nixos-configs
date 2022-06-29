# common/modules/watchtower/default.nix
{ ... }:
{
  imports = [
    ./alertmanager.nix
    ./prometheus.nix
    ./pushgateway.nix
  ];
}
