{ config, pkgs, ... }:
{
  services.rpcbind.enable = true;
  systemd.mounts = [{
    type = "nfs";
    mountConfig = {
      Options = "noatime";
    };
    what = "10.1.0.7:/mnt/tank/services/gitea";
    where = "/var/lib/gitea";
  }];
}
