# ops/home/network.nix

{
  network = {
    description = "Home Lab";
  };

  "nixos-02" = { config, pkgs, lib, ... }: {
    deployment.targetUser = "root";
    deployment.targetHost = "192.168.1.86";

    # Mara\ Import mako's configuration.nix
    imports = [ ../../hosts/nixos-02/configuration.nix ];
  };

}
