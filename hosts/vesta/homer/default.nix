{ pkgs, ... }:
let
  proxmoxReadonlyToken = "root@pam!homer=e1bd8fcb-1733-4839-ab1b-834152b31cbc";
in
{
  services.homer = {
    enable = true;
    virtualHost = {
      nginx.enable = true;
      domain = "homer.j3ff.io";
    };
    settings = {
      title = "Cloyster Dashboard";
      subtitle = "Homer";
      icon = "fas fa-skull-crossbones";

      services = [
        {
          name = "Watchtower";
          logo = "/icons/prometheus.svg";
          items = [
            {
              name = "Grafana";
              logo = "/icons/grafana.svg";
              subtitle = "Dashboards Server";
              keywords = "watchtower dashboard";
              url = "http://grafana.j3ff.io";
              target = "_blank";
            }
            {
              name = "Promethus";
              type = "Prometheus";
              logo = "/icons/prometheus.svg";
              url = "http://prometheus.j3ff.io";
              target = "_blank";
            }
            {
              name = "Alert Manager";
              logo = "/icons/prometheus.svg";
              subtitle = "Alerts Server";
              keywords = "watchtower dashboard";
              url = "http://alertmanager.j3ff.io";
              target = "_blank";
            }
          ];
        }

        {
          name = "Proxmox";
          logo = "/icons/proxmox.svg";
          items = [
            {
              name = "PVE-1";
              logo = "/icons/proxmox.svg";
              type = "Proxmox";
              url = "https://pve-1.lan.j3ff.io";
              target = "_blank";
              node = "pve-1";
              warning_value = 50;
              danger_value = 80;
              api_token = "PVEAPIToken=${proxmoxReadonlyToken}";
              hide_decimals = true;
              small_font_on_desktop = true;
            }
            {
              name = "PVE-2";
              logo = "/icons/proxmox.svg";
              type = "Proxmox";
              url = "https://pve-2.lan.j3ff.io";
              target = "_blank";
              node = "pve-2";
              warning_value = 50;
              danger_value = 80;
              api_token = "PVEAPIToken=${proxmoxReadonlyToken}";
              hide_decimals = true;
              small_font_on_desktop = true;
            }
            {
              name = "PVE-1 BMC";
              icon = "fa-solid fa-server";
              subtitle = "SuperMicro SYS-510T-MR";
              keywords = "proxmox bmc server";
              url = "https://10.1.0.8/";
              target = "_blank";
            }
          ];
        }
      ];
    };
  };

  services.nginx.virtualHosts."homer.j3ff.io".locations."/icons/" =
    let
      iconsDir = pkgs.stdenv.mkDerivation {
        name = "homer-icons";
        src = ./icons;
        phases = [ "installPhase" ];
        installPhase = ''
          cp -r $src $out
        '';
      };
    in
    {
      alias = "${iconsDir}/";
    };
}
