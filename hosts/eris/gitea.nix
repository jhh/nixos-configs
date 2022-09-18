{ config, pkgs, ... }:
{
  # services.rpcbind.enable = true;
  # systemd.mounts = [{
  #   type = "nfs";
  #   mountConfig = {
  #     Options = "noatime";
  #   };
  #   what = "10.1.0.7:/mnt/tank/services/gitea";
  #   where = "/var/lib/gitea";
  #   before = [ "systemd-tmpfiles-setup.service" ];
  # }];

  services.gitea = {
    enable = true;
    domain = "j3ff.io";
    rootUrl = "http://eris.ts.j3ff.io:3000/";
    database.type = "postgres";

  };
}
