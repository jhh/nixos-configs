{ config, pkgs, ... }: {
  services.grafana = {
    enable = true;
    domain = "grafana.j3ff.io";
    port = 2342;
    addr = "127.0.0.1";
    declarativePlugins = with pkgs.grafanaPlugins; [ grafana-piechart-panel ];

    provision = {
      enable = true;
      datasources = [
        {
          name = "Prometheus";
          type = "prometheus";
          access = "proxy";
          isDefault = true;
          url = "http://127.0.0.1:${toString config.services.prometheus.port}";
        }
      ];
    };
  };

  services.nginx = {
    enable = true;
    recommendedProxySettings = true;

    virtualHosts.${config.services.grafana.domain} = {
      locations."/" = {
        proxyPass = "http://127.0.0.1:${toString config.services.grafana.port}";
        proxyWebsockets = true;
      };
    };
  };
}
