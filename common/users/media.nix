# common/users/media.nix

{ flakes, config, pkgs, ... }:

{
  users = {
    users.media = {
      uid = 994;
      group = "media";
      shell = null;
      isSystemUser = true;
    };
    groups.media = { gid = 994; };
  };

}
