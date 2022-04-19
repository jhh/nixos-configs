{ flakes, config, pkgs, ... }:
{
  imports =
    [
      flakes.nixos-hardware.nixosModules.common-cpu-intel
      ./hardware-configuration.nix
      ./grafana.nix
      ./prometheus.nix
    ];

  j3ff = {
    mail.enable = true;
    mdns.enable = true;
    prometheus.enable = true;
    smartd.enable = true;
    tailscale.enable = true;
    ups.enable = true;
    zfs = {
      enable = true;
      enableTrim = true;
    };
    zrepl.enable = true;
  };


  hardware.cpu.intel.updateMicrocode = true;
  services.thermald.enable = true;
  virtualisation.docker.enable = true;

  boot = {
    kernelPackages = config.boot.zfs.package.latestCompatibleLinuxPackages;
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    supportedFilesystems = [ "zfs" ];
  };

  networking = {
    hostName = "eris";
    useNetworkd = true;
    useDHCP = false;
    interfaces.eno1 = {
      useDHCP = false;
      ipv4.addresses = [{
        address = "192.168.1.46";
        prefixLength = 24;
      }];
    };
    defaultGateway = "192.168.1.1";
    nameservers = [ "1.1.1.1" "1.0.0.1" "8.8.8.8" ];
    hostId = "1d6f98a2";
    firewall.enable = false;
  };

  fileSystems."/root" = {
    device = "rpool/safe/home/root";
    fsType = "zfs";
  };

  fileSystems."/home/jeff" = {
    device = "rpool/safe/home/jeff";
    fsType = "zfs";
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "21.05"; # Did you read the comment?

}
