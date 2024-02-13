{ config, pkgs, ... }:
let
  mediaUser = "media";
  mediaGroup = "media";
  sabnzbdDataDir = "/var/lib/sabnzbd";
in
{

  # sonarr

  services.sonarr = {
    enable = true;
    user = mediaUser;
    group = mediaGroup;
  };

  # radarr

  services.radarr = {
    enable = true;
    user = mediaUser;
    group = mediaGroup;
  };


  # sabnzbd

  systemd.tmpfiles.rules = [
    "d '${sabnzbdDataDir}' 0700 ${mediaUser} ${mediaGroup} - -"
  ];

  services.sabnzbd = {
    enable = true;
    user = mediaUser;
    group = mediaGroup;
  };

  # nginx


  services.nginx = {
    enable = true;
    recommendedProxySettings = true;
    recommendedOptimisation = true;
    recommendedGzipSettings = true;
  };

  services.nginx.virtualHosts = {
    "sonarr.j3ff.io" = {
      locations = {
        "/" = {
          proxyPass = "http://127.0.0.1:8989";
        };
      };
    };

    "radarr.j3ff.io" = {
      locations = {
        "/" = {
          proxyPass = "http://127.0.0.1:7878";
        };
      };
    };

    "sabnzbd.j3ff.io" = {
      locations = {
        "/" = {
          proxyPass = "http://127.0.0.1:8080";
        };
      };
    };
  };

}
