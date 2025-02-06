{
  flake,
  inputs,
  pkgs,
  ...
}:
{
  imports = [
    inputs.srvos.nixosModules.server
    inputs.srvos.nixosModules.mixins-systemd-boot
    flake.modules.nixos.server-j3ff
    flake.modules.nixos.smartd
    flake.modules.nixos.zfs
    flake.modules.nixos.zrepl
    ./hardware-configuration.nix
    ./nfs.nix
    ./plex.nix
    ./samba.nix
    ./rclone.nix
  ];

  nixpkgs.hostPlatform = "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = true;

  boot = {
    kernelParams = [ "zfs.zfs_arc_max=30064771072" ];
  };

  services.getty.autologinUser = "root";
  services.thermald.enable = false; # unsupported

  virtualisation.docker.enable = false;

  j3ff = {
    ups.enable = true;

    zrepl = {
      enable = true;
      filesystems = {
        "rpool/safe<" = true;
        "rpool/safe/root" = false;
        "rpool/tank/media<" = true;
        "rpool/tank/share<" = true;
        "rpool/tank/backup<" = true;
      };
      extraJobs = [
        {
          name = "sink";
          type = "sink";
          serve = {
            type = "tcp";
            listen = ":29491";
            clients = {
              "100.64.244.48" = "phobos";
            };
          };
          root_fs = "rpool/zrepl";
          recv.placeholder.encryption = "off";
        }
      ];
    };
  };

  environment.etc."mdadm.conf".text = ''
    MAILADDR root
  '';

  networking = {
    hostName = "luna";
    useDHCP = false;

    bonds = {
      bond0 = {
        interfaces = [
          "enp4s0f0"
          "enp4s0f1"
        ];
        driverOptions = {
          miimon = "100";
          mode = "802.3ad";
          xmit_hash_policy = "layer2+3";
        };
      };
    };

    interfaces.bond0 = {
      useDHCP = false;
      ipv4.addresses = [
        {
          address = "10.1.0.7";
          prefixLength = 24;
        }
      ];
    };

    interfaces.enp5s0f0.useDHCP = false;
    interfaces.enp5s0f1.useDHCP = false;

    defaultGateway = {
      address = "10.1.0.1";
      interface = "bond0";
    };

    hostId = "1200ccec";
  };

  services.avahi = {
    enable = true;
    nssmdns4 = true;
    publish = {
      enable = true;
      addresses = true;
      hinfo = true;
      userServices = true;
      workstation = true;
    };
    extraServiceFiles = {
      ssh = "${pkgs.avahi}/etc/avahi/services/ssh.service";
    };
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
