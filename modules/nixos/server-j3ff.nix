{
  config,
  pkgs,
  ...
}:
{
  imports = [
    ./common-j3ff.nix
    ./node-exporter.nix
  ];

  environment.systemPackages = with pkgs; [
    file
    mailutils
  ];

  networking = {
    domain = "j3ff.io";
    search = [ "j3ff.io" ];

    nameservers = [
      "1.1.1.1"
      "1.0.0.1"
      "8.8.8.8"
      "8.8.4.4"
    ];
  };

  services.postfix = {
    enable = true;
    settings.main = {
      inherit (config.networking) domain;
      relayhost = [ "[smtp.fastmail.com]:587" ];
      "append_dot_mydomain" = "yes";
      "smtp_sasl_auth_enable" = "yes";
      "smtp_sasl_password_maps" = "hash:/etc/postfix/sasl_passwd";
      "smtp_sasl_security_options" = "noanonymous";
      "inet_protocols" = "ipv4";
    };
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
  services.tailscale.openFirewall = true;

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
