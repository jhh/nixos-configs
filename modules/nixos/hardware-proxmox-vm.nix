{ inputs, pkgs, ... }:
{
  imports = [
    inputs.srvos.nixosModules.server
  ];

  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sda";

  services = {
    qemuGuest.enable = true;
    fstrim.enable = true;
    getty.autologinUser = "root";
  };
}
