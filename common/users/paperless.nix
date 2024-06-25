{ config, pkgs, ... }:
{
  age.secrets.paperless_passwd = {
    file = ../../secrets/paperless_passwd.age;
  };

  users.users.paperless = {
    isSystemUser = true;
    uid = 315;
    home = "/var/lib/paperless";
    group = "paperless";
    hashedPasswordFile = config.age.secrets.paperless_passwd.path;
  };

  users.groups.paperless = { gid = 315; };

}
