{ config, pkgs, ... }:
{
  age.secrets.dnsimple_secrets = {
    file = ../../secrets/dnsimple_secrets.age;
  };

  services.caddy = {
    enable = true;

    # https://wiki.nixos.org/wiki/Caddy#Plug-ins
    package = pkgs.caddy.withPlugins {
      plugins = [ "github.com/caddy-dns/dnsimple@v0.0.0-20251214142352-69317c3989f0" ];
      hash = "sha256-FdTcJu3iqZuHK/SRvW57YTSKxeCF9gWMhRHECCO4FnY=";
    };

    environmentFile = config.age.secrets.dnsimple_secrets.path;

    globalConfig = ''
      acme_dns dnsimple {$DNSIMPLE_API_ACCESS_TOKEN}
    '';

  };

  networking.firewall = {
    allowedTCPPorts = [
      80
      443
    ];
  };
}
