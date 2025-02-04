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
    inputs.srvos.nixosModules.server
    # ./postgresql.nix
    # ./todo.nix
  ];

  environment.systemPackages = [ pkgs.ghostty.terminfo ];

  users.users.root = {
    # https://start.1password.com/open/i?a=7Z533SZAYZCNVL764G5INOV75Q&v=lwpxghrefna57cr6nw7mr3bybm&i=v6cyausjzre6hjypvdsfhlkbty&h=my.1password.com
    hashedPassword = "$y$j9T$6B8V0Z9VkFiU0fMwSuLrA0$z3YHuwwAZro3N7TopVIsNltIJ5BXt3TQj1wQqt5HSuD";
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPqpWpNJzfzioGYyR9q4wLwPkBrnmc/Gdl6JsO+SUpel jeff@j3ff.io"
    ];
  };

  # j3ff = {
  #   mail.enable = true;
  #   tailscale.enable = false;
  #   man.enable = true;
  #   mdns.enable = true;
  # };

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
  };

  system.stateVersion = "24.05";

}
