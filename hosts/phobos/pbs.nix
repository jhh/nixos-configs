{
  config,
  lib,
  pkgs,
  ...
}:
{
  age.secrets.pbs_gembrit = {
    file = ../../secrets/pbs_gembrit.age;
  };

  systemd.services.pbs-backup = {
    startAt = "daily";

    serviceConfig = {
      EnvironmentFile = config.age.secrets.pbs_gembrit.path;
      ExecStart = ''
        ${lib.getExe pkgs.proxmox-backup-client} backup strykeforce.pxar:/mnt/tank/share/strykeforce --ns daily
      '';
    };
  };

}
