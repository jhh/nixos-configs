# ops/home/network.nix
let
  # Pin the deployment package-set to a specific version of nixpkgs
  pkgs = import (builtins.fetchGit {
    name = "nixos-21.05";
    url = "https://github.com/NixOS/nixpkgs/";
    ref = "release-21.05";
    rev = "ba6124b6214db87261c71bd80e09e345d30d4af1";
  }) {};
in
{
  network = {
    inherit pkgs;
    description = "Home Lab";
  };

  "nixos-02" = { config, pkgs, lib, ... }: {
    deployment.targetUser = "root";
    deployment.targetHost = "192.168.1.86";

    # Mara\ Import mako's configuration.nix
    imports = [ ../../hosts/nixos-02/configuration.nix ];
  };

}
