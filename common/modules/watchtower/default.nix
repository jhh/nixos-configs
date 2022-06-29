# common/modules/watchtower/default.nix
{ ... }:
{
  imports = [
    ./alertmanager.nix
    ./grafana.nix
    ./prometheus.nix
    ./pushgateway.nix
  ];
}
