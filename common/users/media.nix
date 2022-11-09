# common/users/media.nix

{ flakes, config, pkgs, ... }:

{
  users = {
    users.media = {
      group = "media";
      shell = null;
      isSystemUser = true;
    };
    groups.media = { };
  };

}
