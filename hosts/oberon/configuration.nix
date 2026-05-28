{
  flake,
  pkgs,
  ...
}:

{
  imports = [
    flake.modules.nixos.server-j3ff
    ./podman.nix
    ./hardware-configuration.nix
  ];

  boot.initrd.systemd.enable = true;
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking = {
    hostName = "oberon";
    useDHCP = false;

    interfaces.ens18 = {
      useDHCP = false;
      ipv4.addresses = [
        {
          address = "10.1.0.51";
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
    firewall.enable = false;
  };

  services = {
    openssh.enable = true;
    qemuGuest.enable = true;
    fstrim.enable = true;
    getty.autologinUser = "root";
  };

  users = {
    mutableUsers = false;
    users.root = {
      # https://start.1password.com/open/i?a=7Z533SZAYZCNVL764G5INOV75Q&v=lwpxghrefna57cr6nw7mr3bybm&i=v6cyausjzre6hjypvdsfhlkbty&h=my.1password.com
      hashedPassword = "$y$j9T$6B8V0Z9VkFiU0fMwSuLrA0$z3YHuwwAZro3N7TopVIsNltIJ5BXt3TQj1wQqt5HSuD";
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPqpWpNJzfzioGYyR9q4wLwPkBrnmc/Gdl6JsO+SUpel jeff@j3ff.io"
      ];
    };
  };

  nix.settings.auto-optimise-store = true;
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  time.timeZone = "UTC";

  i18n.defaultLocale = "en_US.UTF-8";

  environment.systemPackages = with pkgs; [
    vim
  ];

  system.stateVersion = "25.11"; # Did you read the comment?

}
