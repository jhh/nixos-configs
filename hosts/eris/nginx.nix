{ config, pkgs, ... }:
{

  users.users.nginx.extraGroups = [ "acme" ];

  age.secrets.route53_secrets = {
    file = ../../secrets/route53_secrets.age;
  };

  security.acme = {
    acceptTerms = true;
    defaults = {
      email = "jeff@j3ff.io";
      dnsProvider = "route53";
      environmentFile = config.age.secrets.route53_secrets.path;
    };
  };
}
