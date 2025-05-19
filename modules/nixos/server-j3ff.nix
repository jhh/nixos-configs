{
  inputs,
  config,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    inputs.agenix.nixosModules.default
    ./node-exporter.nix
  ];

  environment.systemPackages = with pkgs; [
    file
    ghostty.terminfo
    mailutils
  ];

  networking = {
    domain = "lan.j3ff.io";
    search = [ "lan.j3ff.io" ];

    nameservers = [
      "1.1.1.1"
      "1.0.0.1"
      "8.8.8.8"
      "8.8.4.4"
    ];
  };

  programs.fish.enable = true;

  services.postfix = {
    enable = true;
    config = {
      "append_dot_mydomain" = "yes";
      "smtp_sasl_auth_enable" = "yes";
      "smtp_sasl_password_maps" = "hash:/etc/postfix/sasl_passwd";
      "smtp_sasl_security_options" = "noanonymous";
      "inet_protocols" = "ipv4";
    };
    domain = config.networking.domain;
    relayHost = "smtp.fastmail.com";
    relayPort = 587;
    rootAlias = "jeff@j3ff.io";
  };

  nix = {
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 14d";
      randomizedDelaySec = "1h";
    };

    settings = {
      substituters = [
        "https://strykeforce.cachix.org"
      ];

      trusted-public-keys = [
        "strykeforce.cachix.org-1:+ux184cQfS4lruf/lIzs9WDMtOkJIZI2FQHfz5QEIrE="
      ];
    };
  };

  age.secrets.sasl_passwd = {
    file = ../../secrets/sasl_passwd.age;
  };

  systemd.services.postfix.preStart = ''
    ln -sf ${config.age.secrets.sasl_passwd.path} /etc/postfix/sasl_passwd
    ${pkgs.postfix}/bin/postmap /etc/postfix/sasl_passwd
  '';

  services.tailscale.enable = true;
  services.tailscale.openFirewall = true;

  users.users.root = {
    # https://start.1password.com/open/i?a=7Z533SZAYZCNVL764G5INOV75Q&v=lwpxghrefna57cr6nw7mr3bybm&i=v6cyausjzre6hjypvdsfhlkbty&h=my.1password.com
    hashedPassword = "$y$j9T$6B8V0Z9VkFiU0fMwSuLrA0$z3YHuwwAZro3N7TopVIsNltIJ5BXt3TQj1wQqt5HSuD";
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPqpWpNJzfzioGYyR9q4wLwPkBrnmc/Gdl6JsO+SUpel jeff@j3ff.io"
    ];
  };

  users.users.jeff = lib.mkDefault {
    isNormalUser = true;
    createHome = false;
    useDefaultShell = false;
    uid = 1000;
  };

  users = {
    users.media = {
      uid = 994;
      group = "media";
      shell = pkgs.shadow;
      isSystemUser = true;
    };
    groups.media = {
      gid = 994;
    };
  };

  age.secrets.paperless_passwd = {
    file = ../../secrets/paperless_passwd.age;
  };

  users.users.paperless = {
    isSystemUser = true;
    uid = config.ids.uids.paperless;
    home = config.services.paperless.dataDir;
    group = "paperless";
    hashedPasswordFile = config.age.secrets.paperless_passwd.path;
  };

  users.groups.paperless = {
    gid = config.ids.gids.paperless;
  };
}
