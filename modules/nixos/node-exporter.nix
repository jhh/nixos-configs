{ config, lib, ... }:
let
  cfg = config.j3ff.nodeExporter;
in
{
  options = {
    j3ff.nodeExporter.textfileDir = lib.mkOption {
      type = lib.types.str;
      description = "prometheus node exporter textfile collection dir";
      default = "/var/local/prometheus/node-exporter";
    };
  };

  config = {
    systemd.tmpfiles.rules = [
      "d ${cfg.textfileDir} 0755 node-exporter node-exporter 10d -"
    ];

    services.prometheus = {
      exporters = {
        node = {
          enable = true;
          enabledCollectors = [ "systemd" ];
          port = 9002;
          openFirewall = true;
          extraFlags = [
            "--collector.textfile.directory ${cfg.textfileDir}"
          ];
        };
      };
    };
  };
}
