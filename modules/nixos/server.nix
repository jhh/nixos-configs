{
  inputs,
  config,
  pkgs,
  ...
}:
{
  imports = [
    inputs.agenix.nixosModules.default
  ];

  environment.systemPackages = with pkgs; [
    ghostty.terminfo
    mailutils
  ];

  networking = {
    domain = "lan.j3ff.io";

    nameservers = [
      "1.1.1.1"
      "1.0.0.1"
      "8.8.8.8"
      "8.8.4.4"
    ];
  };

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

  age.secrets.sasl_passwd = {
    file = ../../secrets/sasl_passwd.age;
  };

  systemd.services.postfix.preStart = ''
    ln -sf ${config.age.secrets.sasl_passwd.path} /etc/postfix/sasl_passwd
    ${pkgs.postfix}/bin/postmap /etc/postfix/sasl_passwd
  '';

  services.tailscale.enable = true;

  users.users.root = {
    # https://start.1password.com/open/i?a=7Z533SZAYZCNVL764G5INOV75Q&v=lwpxghrefna57cr6nw7mr3bybm&i=v6cyausjzre6hjypvdsfhlkbty&h=my.1password.com
    hashedPassword = "$y$j9T$6B8V0Z9VkFiU0fMwSuLrA0$z3YHuwwAZro3N7TopVIsNltIJ5BXt3TQj1wQqt5HSuD";
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPqpWpNJzfzioGYyR9q4wLwPkBrnmc/Gdl6JsO+SUpel jeff@j3ff.io"
    ];
  };
}
