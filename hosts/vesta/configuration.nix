{
  flake,
  inputs,
  pkgs,
  ...
}:
{
  imports = [
    flake.modules.nixos.hardware-proxmox-lxc
    flake.modules.nixos.server-j3ff
    inputs.srvos.nixosModules.mixins-nginx
    flake.modules.nixos.watchtower
    flake.modules.nixos.home-manager-jeff
  ];

  networking.hostName = "vesta";
  nixpkgs.hostPlatform = "x86_64-linux";

  j3ff.watchtower = {
    alertmanager.enable = true;
    prometheus.enable = true;
    pushgateway.enable = true;
    grafana.enable = true;
    exporters = {
      nut.enable = true;
      pihole.enable = false;
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

  system.stateVersion = "21.05";
}
