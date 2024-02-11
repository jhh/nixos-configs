# common/users/jeff.nix

{ config, pkgs, lib, vscode-server, ... }:

{
  users.users.jeff = {
    isNormalUser = true;
    uid = 1000;
    shell = pkgs.fish;
    home = "/home/jeff";
    description = "Jeff Hutchison";
    extraGroups = [ "docker" "strykeforce" "wheel" ];
    openssh.authorizedKeys.keys = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPqpWpNJzfzioGYyR9q4wLwPkBrnmc/Gdl6JsO+SUpel jeff@j3ff.io" ];
  };

  home-manager.users.jeff.imports = [
    ../home-manager
    "${vscode-server}/modules/vscode-server/home.nix"
  ] ++ lib.optional config.j3ff.gui.enable ../home-manager/gui;
}
