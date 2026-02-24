{ pkgs, ... }:
let
  proxmoxReadonlyToken = "root@pam!homer=e1bd8fcb-1733-4839-ab1b-834152b31cbc";
  paperlessReadonlyToken = "6e927a9c4aaeb182b70cf79697771a1cd69b4abe";
  service = s: s // { target = "_blank"; };

  proxmoxService =
    p:
    (service p)
    // {
      logo = "/icons/proxmox.svg";
      type = "Proxmox";
      warning_value = 50;
      danger_value = 80;
      api_token = "PVEAPIToken=${proxmoxReadonlyToken}";
      hide_decimals = true;
      small_font_on_desktop = true;
    };

  grafana = service {
    name = "Grafana";
    logo = "/icons/grafana.svg";
    subtitle = "Dashboards Server";
    keywords = "watchtower dashboard";
    url = "http://grafana.j3ff.io";
  };

  prometheus = service {
    name = "Prometheus";
    type = "Prometheus";
    logo = "/icons/prometheus.svg";
    url = "http://prometheus.j3ff.io";
  };

  alertmanager = service {
    name = "Alert Manager";
    logo = "/icons/prometheus.svg";
    subtitle = "Alerts Server";
    keywords = "watchtower dashboard";
    url = "http://alertmanager.j3ff.io";
  };

  pve-1 = proxmoxService {
    name = "PVE-1";
    url = "https://pve-1.lan.j3ff.io";
    node = "pve-1";
  };

  pve-2 = proxmoxService {
    name = "PVE-2";
    url = "https://pve-2.lan.j3ff.io";
    node = "pve-2";
  };

  pve-1-dashboard = {
    name = "PVE-1 Grafana Dashboard";
    logo = "/icons/grafana.svg";
    keywords = "proxmox watchtower dashboard";
    url = "http://grafana.j3ff.io/d/rYdddlPWk/node-exporter-full?orgId=1&from=now-24h&to=now&timezone=browser&var-datasource=default&var-job=node&var-node=pve-1&var-diskdevices=%5Ba-z%5D%2B%7Cnvme%5B0-9%5D%2Bn%5B0-9%5D%2B%7Cmmcblk%5B0-9%5D%2B&refresh=1m";
    target = "_blank";
  };

  pve-2-dashboard = {
    name = "PVE-2 Grafana Dashboard";
    logo = "/icons/grafana.svg";
    keywords = "proxmox watchtower dashboard";
    url = "http://grafana.j3ff.io/d/rYdddlPWk/node-exporter-full?orgId=1&from=now-24h&to=now&timezone=browser&var-datasource=default&var-job=node&var-node=pve-2&var-diskdevices=%5Ba-z%5D%2B%7Cnvme%5B0-9%5D%2Bn%5B0-9%5D%2B%7Cmmcblk%5B0-9%5D%2B&refresh=1m";
    target = "_blank";
  };

  pve-1-bmc = service {
    name = "PVE-1 BMC";
    icon = "fa-solid fa-server";
    subtitle = "SuperMicro SYS-510T-MR (ADMIN)";
    keywords = "proxmox bmc kvm server";
    url = "https://10.1.0.8/";
  };

  pve-2-kvm = service {
    name = "PVE-2 KVM";
    icon = "fa-solid fa-server";
    subtitle = "Intel NUC";
    keywords = "proxmox kvm server";
    url = "https://app.jetkvm.com/devices/8199000ecb116d7b";
  };

  pbs-2-kvm = service {
    name = "PBS-2 KVM";
    icon = "fa-solid fa-server";
    subtitle = "Intel NUC";
    keywords = "proxmox kvm server";
    url = "https://app.jetkvm.com/devices/58d1c556689ac54a";
  };

  luna-bmc = {
    name = "Luna BMC";
    icon = "fa-solid fa-server";
    subtitle = "Asrock Rack C3558D4I-4L (admin)";
    keywords = "proxmox kvm server";
    url = "http://10.1.0.6/";
    target = "_blank";
  };

  blocky-dashboard = service {
    name = "Grafana Dashboard";
    logo = "/icons/grafana.svg";
    keywords = "dns blocky watchtower dashboard";
    url = "http://grafana.j3ff.io/d/JvOqE4gR1/blocky";
  };

  blocky-docs = service {
    name = "Documentation";
    icon = "fa-solid fa-book";
    keywords = "documentation docs dns blocky";
    url = "https://0xerr0r.github.io/blocky/latest/";
  };

  calibre = service {
    name = "Calibre";
    logo = "/icons/calibre.svg";
    url = "http://calibre.j3ff.io";
  };

  gitea = service {
    name = "Gitea";
    logo = "/icons/gitea.svg";
    type = "Gitea";
    url = "https://gitea.j3ff.io";
  };

  miniflux = service {
    name = "Miniflux";
    logo = "/icons/miniflux.svg";
    url = "http://miniflux.j3ff.io";
  };

  paperless = service {
    name = "Paperless";
    logo = "/icons/paperless-ngx.svg";
    type = "PaperlessNG";
    url = "https://paperless.j3ff.io";
    apikey = paperlessReadonlyToken;
  };

  puka = service {
    name = "Puka";
    logo = "/icons/puka.svg";
    url = "https://puka.j3ff.io";
  };

  pgadmin = service {
    name = "Pgadmin";
    logo = "/icons/pgadmin.svg";
    url = "http://pgadmin.j3ff.io";
  };

  watchtower = {
    name = "Watchtower";
    logo = "/icons/prometheus.svg";
    items = [
      grafana
      prometheus
      alertmanager
    ];
  };

  proxmox = {
    name = "Proxmox";
    logo = "/icons/proxmox.svg";
    items = [
      pve-1
      pve-1-dashboard
      pve-2
      pve-2-dashboard
    ];
  };

  consoles = {
    name = "Server Consoles";
    logo = "/icons/jetkvm.svg";
    items = [
      pve-1-bmc
      pve-2-kvm
      luna-bmc
      pbs-2-kvm
    ];
  };

  blocky = {
    name = "Blocky";
    logo = "/icons/blocky.svg";
    subtitle = "DNS proxy and ad-blocker";
    items = [
      blocky-dashboard
      blocky-docs
    ];
  };

  apps = {
    name = "Applications";
    logo = "/icons/safari-ios.svg";
    items = [
      calibre
      gitea
      miniflux
      paperless
      pgadmin
      puka
    ];
  };
in
{
  services.homer = {
    enable = true;
    virtualHost = {
      caddy.enable = true;
      domain = "homer.j3ff.io";
    };
    settings = {
      title = "Cloyster Homelab";
      subtitle = "Homer";
      logo = "/icons/homer.svg";

      services = [
        apps
        watchtower
        proxmox
        consoles
        blocky
      ];
    };
  };

  services.caddy.virtualHosts."homer.j3ff.io".extraConfig =
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
    ''
      handle_path /icons/* {
          root * ${iconsDir}
          file_server
      }
    '';

}
