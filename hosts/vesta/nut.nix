{ config, pkgs, ... }:
let
  nut-exporter = pkgs.buildGoModule
    rec {
      pname = "nut-exporter";
      version = "2.4.2";

      src = pkgs.fetchFromGitHub {
        owner = "DRuggeri";
        repo = "nut_exporter";
        rev = "v${version}";
        sha256 = "sha256-fymVx6FJGII2PmWXVfeCRTxfO+35bmyn/9iL0iPuBgo=";
      };

      vendorSha256 = "sha256-ji8JlEYChPBakt5y6+zcm1l04VzZ0/fjfGFJ9p+1KHE=";
    };
in
{
  systemd.services.nut-exporter = {
    description = "NUT Prometheus exporter";
    wantedBy = [ "multi-user.target" ];
    requires = [ "network-online.target" ];
    after = [ "network-online.target" ];

    serviceConfig = {
      ExecStart = "${nut-exporter}/bin/nut_exporter --nut.server=10.1.0.9";
    };
  };
}
