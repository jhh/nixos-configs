# common/users/default.nix

# Inputs to this NixOS module, in this case we are
# using `pkgs` so I can configure my favorite shell fish
# and `config` so we can make my SSH key also work with
# the root user.
{ config, pkgs, ... }:

{
  users.users.jeff = {
    isNormalUser = true;
    shell = pkgs.fish;
    
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPqpWpNJzfzioGYyR9q4wLwPkBrnmc/Gdl6JsO+SUpel jeff@j3ff.io"
    ];
  };
  
  users.users.root.openssh.authorizedKeys.keys =
    config.users.users.jeff.openssh.authorizedKeys.keys;
}
