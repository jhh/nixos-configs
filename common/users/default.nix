# common/users/default.nix

{ config, pkgs, ... }:

{
  users = {
    mutableUsers = false;

    users = {
      jeff = {
        isNormalUser = true;
        uid = 1000;
        shell = pkgs.fish;
        home = "/home/jeff";
        description = "Jeff Hutchison";
        extraGroups = [ "wheel" ];
        openssh.authorizedKeys.keys = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPqpWpNJzfzioGYyR9q4wLwPkBrnmc/Gdl6JsO+SUpel jeff@j3ff.io" ];
      };

      root = {
        openssh.authorizedKeys.keys = config.users.users.jeff.openssh.authorizedKeys.keys;
      };
    };
  };
}
