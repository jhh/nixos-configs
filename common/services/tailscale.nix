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
  };
}
