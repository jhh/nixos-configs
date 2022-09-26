{ config, pkgs, ... }: {

  age.secrets.miniflux_secret =
    {
      file = ../../common/modules/secrets/miniflux_secret.age;
    };

  services.miniflux = {
    enable = true;
    config = {
      LISTEN_ADDR = "0.0.0.0:8010";
    };
    adminCredentialsFile = config.age.secrets.miniflux_secret.path;
  };

}
