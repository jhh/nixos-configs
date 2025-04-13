{ pkgs, ... }:
{
  services.webdav = {
    enable = true;
    settings = {
      directory = "/mnt/tank/services/webdav";
      address = "0.0.0.0";
      port = 6065;
      tls = false;
      permission = "CRUD";
      users = [
        {
          username = "jeff";
          password = "";
          permissions = "CRUD";
        }
      ];
    };
  };
}
