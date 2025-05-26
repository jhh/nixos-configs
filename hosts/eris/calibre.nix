{ ... }:
{

  services.calibre-server = {
    enable = true;
    openFirewall = true;
    libraries = [
      "/mnt/calibre"
    ];
  };

  services.nginx.virtualHosts."calibre.j3ff.io" = {
    locations = {
      "/" = {
        proxyPass = "http://127.0.0.1:8080";
      };
    };
  };
}
