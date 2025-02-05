{
  flake,
  pkgs,
  ...
}:
{
  imports = [
    flake.modules.nixos.hardware-proxmox-lxc
    flake.modules.nixos.j3ff-server
    flake.modules.nixos.watchtower
    flake.modules.nixos.jeff
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
      pihole.enable = true;
      unifi.enable = true;
    };
  };

  systemd.services.jeff-backup = {
    startAt = "hourly";
    environment = {
      BACKUP_HOST = "luna.lan.j3ff.io";
      RSYNC_RSH = "${pkgs.openssh}/bin/ssh";
    };
    script = ''
      echo backing up /home/jeff
      ${pkgs.rsync}/bin/rsync -az --delete /home/jeff jeff@$BACKUP_HOST:backup/vesta/
    '';
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
