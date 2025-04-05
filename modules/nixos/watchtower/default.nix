# common/modules/watchtower/default.nix
{ ... }:
{
  imports = [
    ./alertmanager.nix
    ./grafana.nix
    ./nut-exporter.nix
    ./prometheus
    ./pushgateway.nix
    ./pihole-exporter.nix
    ./unifi-exporter.nix
  ];
}
