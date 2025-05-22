{ ... }:
{

  services.calibre-server = {
    enable = true;
    openFirewall = true;
    libraries = [
      "/mnt/calibre"
    ];
  };

}
