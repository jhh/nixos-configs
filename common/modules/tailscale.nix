{ config, lib, pkgs, ... }:
{
  options = {
    j3ff.tailscale.enable = lib.mkEnableOption "Tailscale VPN";
  };

  config = lib.mkIf config.j3ff.tailscale.enable {

    environment.systemPackages = [
      pkgs.tailscale
    ];

    services.tailscale.enable = true;

    systemd.services."systemd-networkd-wait-online" = lib.mkIf config.networking.useNetworkd {
      serviceConfig = {
        ExecStart = [
          "" # systemd will clear the ExecStart list
          "${pkgs.systemd}/lib/systemd/systemd-networkd-wait-online --timeout=120 --ignore=tailscale0"
        ];
      };
    };
  };
}
