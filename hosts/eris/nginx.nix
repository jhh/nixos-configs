{ config, pkgs, ... }: {

  users.users.nginx.extraGroups = [ "acme" ];

  services.nginx = {
    enable = true;
    recommendedProxySettings = true;

    # virtualHosts."puka.j3ff.io" = {
    #   forceSSL = true;
    #   useACMEHost = "puka.j3ff.io";

    #   locations = {
    #     "/" = {
    #       proxyPass = "http://127.0.0.1:8000";
    #     };
    #   };
    # };
  };

  age.secrets.route53_secrets = {
    file = ../../common/modules/secrets/route53_secrets.age;
  };

  security.acme = {
    acceptTerms = true;
    defaults.email = "jeff@j3ff.io";
    certs."puka.j3ff.io" = {
      dnsProvider = "route53";
      credentialsFile = "/run/agenix/route53_secrets";
    };
  };

}
