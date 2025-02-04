{
  flake,
  inputs,
  perSystem,
  pkgs,
  ...
}:

{
  imports = [
    ./hardware-configuration.nix
    flake.modules.nixos.hardware-proxmox-vm
    flake.modules.nixos.server
    # ./postgresql.nix
    # ./todo.nix
  ];

  # j3ff = {
  #   mail.enable = true;
  #   tailscale.enable = false;
  #   man.enable = true;
  #   mdns.enable = true;
  # };

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
  };

  system.stateVersion = "24.05";

}
