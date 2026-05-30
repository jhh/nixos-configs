{ ... }:
{
  virtualisation.oci-containers.containers = {
    explo = {
      image = "ghcr.io/lumepart/explo:latest";
      ports = [ "7288:7288" ];
      environment = {
        TZ = "America/Detroit";
        WEB_UI = "true";
        UI_USERNAME = "jeff";
        UI_PASSWORD = "testpassword";
      };
      volumes = [
        "/var/lib/explo/env:/opt/explo/.env"
        "/var/lib/explo/config:/opt/explo/config"
        "/var/lib/explo/music:/data/"
      ];

      extraOptions = [ "--restart=no" ];
    };
  };
}
