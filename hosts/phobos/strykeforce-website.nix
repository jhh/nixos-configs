{ config, pkgs, ... }: {
  # added phobos in sercrets.nix
  age.secrets.stryker_website_secrets = {
    file = ../../common/modules/secrets/strykeforce_website_secrets.age;
  };
  strykeforce.services.website = {
    enable = true;
    ssl = false;
    settingsModule = "website.settings.production";
    allowedHosts = "phobos.strykeforce.org strykeforce-staging.strykeforce.org";
  };

  services.nginx.virtualHosts."strykeforce-staging.strykeforce.org" = {
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
