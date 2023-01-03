{ config, pkgs, ... }:
{
  age.secrets.minio_secret = {
    file = ../../common/modules/secrets/minio_secret.age;
  };

  services.minio = {
    enable = true;
    dataDir = [ "/mnt/tank/services/minio" ];
    rootCredentialsFile = config.age.secrets.minio_secret.path;
  };

}
