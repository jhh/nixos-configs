{ config, pkgs, ... }:
{
  services.rpcbind.enable = true;
  systemd.mounts = [{
    type = "nfs";
    mountConfig = {
      Options = "noatime";
    };
    what = "10.1.0.7:/mnt/tank/proxmox/pve";
    where = "/mnt/pve";
  }];

  systemd.automounts = [{
    wantedBy = [ "multi-user.target" ];
    automountConfig = {
      TimeoutIdleSec = "60";
    };
    where = "/mnt/pve";
  }];

}
