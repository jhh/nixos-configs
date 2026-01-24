{ ... }:
{
  services.restic.server = {
    enable = true;
    dataDir = "/mnt/tank/backup/restic/";
    extraFlags = [
      "--no-auth"
    ];
  };
}
