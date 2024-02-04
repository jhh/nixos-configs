{ config, pkgs, ... }: {

  age.secrets.miniflux_secret =
    {
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

  services.nginx.virtualHosts."miniflux.j3ff.io" = {
    # security.acme is configured for eris globally in nginx.nix
    forceSSL = true;
    enableACME = true;
    acmeRoot = null;

    locations = {
      "/" = {
        proxyPass = "http://127.0.0.1:8010";
      };
    };
  };
}
