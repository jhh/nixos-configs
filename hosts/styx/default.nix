{
  config,
  lib,
  pkgs,
  ...
}:

{
  imports = [
    ./hardware-configuration.nix
    ./postgresql.nix
    ./todo.nix
  ];

  j3ff = {
    mail.enable = true;
    tailscale.enable = false;
    man.enable = true;
    mdns.enable = true;
  };

  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sda";

  services = {
    qemuGuest.enable = true;
    fstrim.enable = true;
    getty.autologinUser = "root";
  };

  networking = {
    hostName = "styx";
    useDHCP = false;

    interfaces.ens18 = {
      useDHCP = false;
      ipv4.addresses = [
        {
          address = "10.1.0.49";
          prefixLength = 24;
        }
      ];
    };
    defaultGateway = {
      address = "10.1.0.1";
      interface = "ens18";
    };

    nameservers = [
      "1.1.1.1"
      "1.0.0.1"
      "8.8.8.8"
      "8.8.4.4"
    ];
    firewall.enable = false;
  };

  system.stateVersion = "24.05";

}
