{ config, pkgs, ... }:
{
  age.secrets.paperless_passwd = {
    file = ../../secrets/paperless_passwd.age;
  };

  users.users.paperless = {
    isSystemUser = true;
    uid = config.ids.uids.paperless;
    home = config.services.paperless.dataDir;
    group = "paperless";
    hashedPasswordFile = config.age.secrets.paperless_passwd.path;
  };

  users.groups.paperless = { gid = config.ids.gids.paperless; };

}
