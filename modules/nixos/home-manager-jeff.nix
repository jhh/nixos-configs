{
  inputs,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    inputs.home-manager.nixosModules.home-manager
  ];

  users.users.jeff = {
    isNormalUser = true;
    uid = 1000;
    shell = pkgs.fish;
    home = "/home/jeff";
    description = "Jeff Hutchison";
    extraGroups = [
      "wheel"
    ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPqpWpNJzfzioGYyR9q4wLwPkBrnmc/Gdl6JsO+SUpel jeff@j3ff.io"
    ];
  };

  home-manager.users.jeff.imports = [
    inputs.self.homeModules.jeff
    "${inputs.nixos-vscode-server}/modules/vscode-server/home.nix"
  ];

  home-manager.users.jeff.services.vscode-server.enable = lib.mkDefault true;
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
}
