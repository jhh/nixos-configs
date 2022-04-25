{ config, lib, pkgs, ... }:
{
  options = {
    j3ff.mail.enable = lib.mkEnableOption "Emails from host";
  };

  config = lib.mkIf config.j3ff.mail.enable {
    environment.systemPackages = with pkgs; [ mailutils ];

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
      file = ./secrets/sasl_passwd.age;
      path = "/etc/postfix/sasl_passwd";
    };

  };
}
