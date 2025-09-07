{ pkgs, ... }:
{
  services.resolved.enable = false;

  environment.systemPackages = [
    pkgs.dig
  ];

  services.blocky = {
    enable = true;
    settings = {
      bootstrapDns = [
        {
          upstream = "https://cloudflare-dns.com/dns-query";
          ips = [ "104.16.249.249" ];
        }
      ];

      upstreams.groups.default = [
        "1.1.1.1"
        "1.0.0.1"
        "2606:4700:4700::1111"
        "2606:4700:4700::1001"
        "https://cloudflare-dns.com/dns-query"
        "https://dns.google/dns-query"
      ];

      customDNS.mapping = {
        "pve-1.lan.j3ff.io" = "10.1.0.9";
        "pve-2.lan.j3ff.io" = "10.1.0.11";
      };

      hostsFile.sources = [ ./hosts.txt ];

      blocking = {
        denylists.default = [
          "https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts"
        ];
        allowlists.default = [
          ./allowlist.txt
        ];
        clientGroupsBlock.default = [ "default" ];
      };

      caching = {
        minTime = "7m";
        prefetching = true;
      };

      ports.dns = 53;
      ports.http = 9101;
      prometheus.enable = true;

      queryLog = {
        type = "none";
        target = "/var/log/blocky";
      };
    };
  };

  systemd.services.blocky.serviceConfig.LogsDirectory = "blocky";

  networking.firewall.allowedUDPPorts = [ 53 ];
  networking.firewall.allowedTCPPorts = [
    53
    9101
  ];

}
