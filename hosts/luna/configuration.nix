{ config, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      ./nfs.nix
      ./plex.nix
      ./rsync.nix
      ./samba.nix
      ./zrepl.nix
    ];

  hardware.cpu.intel.updateMicrocode = true;

  boot.kernelParams = [ "zfs.zfs_arc_max=29344391168" ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  environment.etc."mdadm.conf".text = ''
    MAILADDR root
  '';

  networking = {
    useDHCP = false;

    bonds = {
      bond0 = {
        interfaces = [ "enp4s0f0" "enp4s0f1" ];
        driverOptions = {
          miimon = "100";
          mode = "802.3ad";
          xmit_hash_policy = "layer2+3";
        };
      };
    };

    interfaces.bond0 = {
      useDHCP = false;
      ipv4.addresses = [{
        address = "192.168.1.7";
        prefixLength = 24;
      }];
    };

    interfaces.enp6s0f0.useDHCP = false;
    interfaces.enp6s0f1.useDHCP = false;

    defaultGateway = "192.168.1.1";
    nameservers = [ "1.1.1.1" "1.0.0.1" "8.8.8.8" ];
    hostId = "1200ccec";
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

