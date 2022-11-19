{ config, pkgs, ... }:
let
  mediaUser = "media";
  mediaGroup = "media";
  sabnzbdDataDir = "/var/lib/sabnzbd";
in
{

  fileSystems."/mnt/media/tv" = {
    device = "luna.lan.j3ff.io:/mnt/tank/media/plex/tv";
    fsType = "nfs";
  };

  fileSystems."/mnt/media/movies" = {
    device = "luna.lan.j3ff.io:/mnt/tank/media/plex/movies";
    fsType = "nfs";
  };

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

  systemd.services.sabnzbd = {
    description = "SABnzbd binary newsreader";
    after = [ "network.target" ];
    wantedBy = [ "multi-user.target" ];

    serviceConfig = {
      Type = "simple";
      User = mediaUser;
      Group = mediaGroup;
      ExecStart = "${pkgs.sabnzbd}/bin/sabnzbd --config-file ${sabnzbdDataDir}/sabnzbd.ini --disable-file-log --logging 1 --browser 0";
      Restart = "on-failure";
    };
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
