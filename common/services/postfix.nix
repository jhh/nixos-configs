{ config, lib, pkgs, ... }:
{
  options = {
    j3ff.mail = lib.mkOption {
      type = lib.types.bool;
      default = false;
    };
  };

  config = lib.mkIf config.j3ff.mail {
    services.postfix = {
      enable = true;
      config = {
        "append_dot_mydomain" = "yes";
        "smtp_sasl_auth_enable" = "yes";
        "smtp_sasl_password_maps" = "hash:/etc/postfix/sasl_passwd";
        "smtp_sasl_security_options" = "noanonymous";
      };
      domain = config.networking.domain;
      relayHost = "smtp.fastmail.com";
      relayPort = 587;
      rootAlias = "jeff@j3ff.io";
    };

    systemd.services.postfix.preStart = ''
      ln -sf /root/sasl_passwd /etc/postfix/sasl_passwd
      ${pkgs.postfix}/bin/postmap /etc/postfix/sasl_passwd
    '';
  };
}
