{ config, pkgs, ... }: {

  users.users.nginx.extraGroups = [ "acme" ];

  services.nginx = {
    enable = true;
    recommendedProxySettings = true;
    recommendedOptimisation = true;
    recommendedGzipSettings = true;
  };

  age.secrets.route53_secrets = {
    file = ../../common/modules/secrets/route53_secrets.age;
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
