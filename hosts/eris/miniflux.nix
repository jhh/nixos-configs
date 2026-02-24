{ config, ... }:
{

  age.secrets.miniflux_secret = {
    file = ../../secrets/miniflux_secret.age;
  };

  services.miniflux = {
    enable = true;
    config = {
      LISTEN_ADDR = "127.0.0.1:8010";
      BASE_URL = "https://miniflux.j3ff.io";
    };
    adminCredentialsFile = config.age.secrets.miniflux_secret.path;
  };

  services.caddy.virtualHosts."miniflux.j3ff.io".extraConfig = ''
    reverse_proxy http://${toString config.services.miniflux.config.LISTEN_ADDR}
  '';

}
