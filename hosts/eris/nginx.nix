{ config, pkgs, ... }: {

  users.users.nginx.extraGroups = [ "acme" ];

  services.nginx = {
    enable = true;
    recommendedProxySettings = true;
    recommendedOptimisation = true;
  };

  age.secrets.route53_secrets = {
    file = ../../common/modules/secrets/route53_secrets.age;
  };

  security.acme = {
    acceptTerms = true;
    defaults = {
      email = "jeff@j3ff.io";
      dnsProvider = "route53";
      credentialsFile = "/run/agenix/route53_secrets";
    };
    certs."puka.j3ff.io" = {
      inheritDefaults = true;
    };
  };

}
