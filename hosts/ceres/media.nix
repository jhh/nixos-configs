{ config, pkgs, ... }:
{

  fileSystems."/mnt/media/tv" = {
    device = "luna.lan.j3ff.io:/mnt/tank/media/plex/tv";
    fsType = "nfs";
  };

  services.sonarr = {
    enable = true;
    user = config.users.users.media;
  };

  services.nginx = {
    enable = true;
    recommendedProxySettings = true;
    recommendedOptimisation = true;
    recommendedGzipSettings = true;
  };

  services.nginx.virtualHosts."sonarr.j3ff.io" = {
    locations = {
      "/" = {
        proxyPass = "http://127.0.0.1:8989";
      };
    };
  };

}
