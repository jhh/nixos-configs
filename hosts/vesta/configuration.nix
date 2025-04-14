{ flake, inputs, ... }:
let
  promNodeTextfilesDir = "/var/local/prometheus/node-exporter";
in
{
  imports = [
    flake.modules.nixos.hardware-proxmox-lxc
    flake.modules.nixos.server-j3ff
    inputs.speedtest.nixosModules.default
    inputs.srvos.nixosModules.mixins-nginx
    flake.modules.nixos.watchtower
    flake.modules.nixos.home-manager-jeff
  ];

  networking.hostName = "vesta";
  nixpkgs.hostPlatform = "x86_64-linux";

  j3ff.watchtower = {
    alertmanager.enable = true;
    prometheus.enable = true;
    pushgateway.enable = false;
    grafana.enable = true;
    exporters = {
      nut.enable = true;
      pihole.enable = false;
      speedtest.enable = true;
      speedtest.interval = "8h";
      unifi.enable = true;
    };
  };

  documentation = {
    enable = true;
    man.enable = true;
    nixos = {
      enable = true;
      includeAllModules = true;
      options.warningsAreErrors = false;
    };
  };

  systemd.services.test = {
    enable = true;
    script = ''
      while true; do
          if [ -f /tmp/fail ]; then
              echo "/tmp/fail exists, exiting..."
              exit -1
          fi
          sleep 1s
      done
    '';
  };

  # prometheus node exporter textfiles collection directory

  systemd.tmpfiles.rules = [
    "d ${promNodeTextfilesDir} 0755 node-exporter node-exporter 10d -"
  ];

  services.prometheus.exporters.node.extraFlags = [
    "--collector.textfile.directory ${promNodeTextfilesDir}"
  ];

  system.stateVersion = "21.05";
}
