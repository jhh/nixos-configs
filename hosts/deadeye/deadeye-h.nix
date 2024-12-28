{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  j3ff = {
    tailscale.enable = true;
    mdns.enable = true;
  };

  # Use the GRUB 2 boot loader.
  boot = {
    loader.grub = {
      enable = true;
      device = "/dev/sda";
    };
  };

  zramSwap.enable = true;

  networking = {
    hostName = "deadeye-h";
    useDHCP = false;

    interfaces.ens18 = {
      useDHCP = false;
      ipv4.addresses = [
        {
          address = "192.168.3.10";
          prefixLength = 24;
        }
      ];
    };

    defaultGateway = "192.168.3.1";
    nameservers = [
      "1.1.1.1"
      "1.0.0.1"
      "8.8.8.8"
    ];
    firewall.enable = false;
  };

  services = {
    fstrim.enable = true;
    qemuGuest.enable = true;
  };

  system.stateVersion = "21.05"; # Did you read the comment?

}
