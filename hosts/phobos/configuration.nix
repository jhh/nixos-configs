{
  config,
  flake,
  inputs,
  ...
}:

{
  imports = [
    inputs.srvos.nixosModules.server
    inputs.srvos.nixosModules.mixins-systemd-boot
    flake.modules.nixos.server-j3ff
    flake.modules.nixos.smartctl-exporter
    flake.modules.nixos.zfs
    flake.modules.nixos.zrepl
    ./hardware-configuration.nix
    ./rclone.nix
    ./samba.nix
    ./zrepl.nix
  ];

  nixpkgs.hostPlatform = "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = true;

  boot = {
    kernelParams = [
      "console=tty1"
      "console=ttyS1,115200"
      "zfs.zfs_arc_max=30064771072"
    ];
  };

  environment.etc."mdadm.conf".text = ''
    MAILADDR root
  '';

  networking = {
    hostName = "phobos";
    useDHCP = false;

    interfaces.enp7s0 = {
      useDHCP = false;
      ipv4.addresses = [
        {
          address = "192.168.3.20";
          prefixLength = 24;
        }
      ];
    };

    interfaces.enp8s0.useDHCP = true;

    defaultGateway = {
      address = "192.168.3.1";
      interface = "enp7s0";
    };
    hostId = "2b7703b8";
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "21.05"; # Did you read the comment?

}
