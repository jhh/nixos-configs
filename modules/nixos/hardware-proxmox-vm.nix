{ inputs, lib, ... }:
{
  imports = [
    inputs.srvos.nixosModules.server
  ];

  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sda";

  networking = {
    useDHCP = false;

    interfaces.ens18 = {
      useDHCP = false;
    };

    defaultGateway = {
      address = "10.1.0.1";
      interface = "ens18";
    };
  };

  services = {
    qemuGuest.enable = true;
    fstrim.enable = true;
    getty.autologinUser = "root";
  };

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}
