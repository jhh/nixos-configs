{ config, pkgs, ... }: {
  age.secrets.stryker_website_secrets = {
    file = ../../common/modules/secrets/strykeforce_website_secrets.age;
  };
  strykeforce.services.website = {
    enable = true;
    ssl = false;
    settingsModule = "website.settings.production";
    allowedHosts = "strykeforce.j3ff.io";
  };

  services.nginx.virtualHosts."strykeforce.j3ff.io" = {
    locations = {
      "/" = {
        proxyPass = "http://127.0.0.1:8000";
      };

      "/media/" = {
        alias = "/var/lib/strykeforce/media/";
        extraConfig = ''
          expires max;
          add_header Cache-Control public;
        '';
      };
    };
  };
}
