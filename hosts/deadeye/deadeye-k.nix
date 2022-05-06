{ config, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
    ];

  j3ff = {
    tailscale.enable = true;
    mdns.enable = true;
  };
  deadeye = {
    web.enable = true;
    admin.enable = true;
    daemon = {
      enable = true;
      unitId = "K";
      pipeline0 = "deadeye::UprightRectPipeline";
      pipeline1 = "deadeye::MinAreaRectPipeline";
      pipeline2 = "deadeye::TargetListPipeline";
      streamAddress = "${(builtins.head config.networking.interfaces.ens18.ipv4.addresses).address}";
    };
    ntServerAddress = "192.168.3.20"; # phobos
  };

  # Use the GRUB 2 boot loader.
  boot = {
    loader.grub = {
      enable = true;
      version = 2;
      device = "/dev/sda";
    };
  };

  zramSwap.enable = true;

  networking = {
    hostName = "deadeye-k";
    useDHCP = false;

    interfaces.ens18 = {
      useDHCP = false;
      ipv4.addresses = [{
        address = "192.168.3.13";
        prefixLength = 24;
      }];
    };

    defaultGateway = "192.168.3.1";
    nameservers = [ "1.1.1.1" "1.0.0.1" "8.8.8.8" ];
    firewall.enable = false;
  };

  services = {
    fstrim.enable = true;
    qemuGuest.enable = true;
  };

  system.stateVersion = "21.05"; # Did you read the comment?

}
