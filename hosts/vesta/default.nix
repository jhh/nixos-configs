{ config, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      ./rsync.nix
    ];

  j3ff = {
    mail.enable = true;
    tailscale.enable = true;
    mdns.enable = true;
  };

  deadeye = {
    web.enable = true;
    admin.enable = true;
    daemon = {
      enable = true;
      unitId = "V";
      pipeline0 = "deadeye::UprightRectPipeline";
      pipeline1 = "deadeye::MinAreaRectPipeline";
      pipeline2 = "deadeye::TargetListPipeline";
      streamAddress = "${(builtins.head config.networking.interfaces.br0.ipv4.addresses).address}";
    };
    ntServerAddress = "192.168.1.7"; # luna
  };

  # Use the GRUB 2 boot loader.
  boot = {
    loader.grub = {
      enable = true;
      version = 2;
      device = "/dev/sda";
    };
    kernel.sysctl = {
      "fs.inotify.max_user_watches" = 524288;
    };
  };

  zramSwap.enable = true;

  networking = {
    hostName = "vesta";
    useDHCP = false;

    bridges."br0" = {
      interfaces = [
        "ens18"
      ];
    };

    interfaces.br0 = {
      useDHCP = false;
      ipv4.addresses = [{
        address = "192.168.1.45";
        prefixLength = 24;
      }];
    };

    defaultGateway = "192.168.1.1";
    nameservers = [ "1.1.1.1" "1.0.0.1" "8.8.8.8" ];
    firewall.enable = false;
  };

  services = {
    fstrim.enable = true;
    qemuGuest.enable = true;
  };

  virtualisation.docker.enable = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "21.05"; # Did you read the comment?

}
