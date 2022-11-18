{ config, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      ./rsync.nix
      ./nfs.nix
    ];

  j3ff = {
    mail.enable = true;
    tailscale.enable = true;
    man.enable = true;
    mdns.enable = true;
    prometheus.enable = true;
    watchtower = {
      alertmanager.enable = true;
      prometheus.enable = true;
      pushgateway.enable = true;
      grafana.enable = true;
      exporters = {
        pihole.enable = true;
      };
    };
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
      streamAddress = "${(builtins.head config.networking.interfaces.ens18.ipv4.addresses).address}";
    };
    ntServerAddress = "10.1.0.7"; # luna
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
      # https://haydenjames.io/linux-performance-almost-always-add-swap-part2-zram/
      "vm.vfs_cache_pressure" = 500;
      "vm.swappiness" = 100;
      "vm.dirty_background_ratio" = 1;
      "vm.dirty_ratio" = 50;
    };
  };

  zramSwap.enable = true;

  networking = {
    hostName = "vesta";
    useDHCP = false;

    # bridges."br0" = {
    #   interfaces = [
    #     "ens18"
    #   ];
    # };

    interfaces.ens18 = {
      useDHCP = false;
      ipv4.addresses = [{
        address = "10.1.0.45";
        prefixLength = 24;
      }];
    };

    defaultGateway = "10.1.0.1";
    nameservers = [ "1.1.1.1" "1.0.0.1" "8.8.8.8" ];
    firewall.enable = false;
  };

  services = {
    fstrim.enable = true;
    qemuGuest.enable = true;
  };

  virtualisation.docker.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "21.05"; # Did you read the comment?

}
