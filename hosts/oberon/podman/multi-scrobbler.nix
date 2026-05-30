{ config, ... }:
let
  port = "9078";
in
{
  age.secrets.multi-scrobbler-env = {
    file = ../../../secrets/multi_scrobbler_secrets.age;
  };

  virtualisation.oci-containers.containers.multi-scrobbler = {
    image = "foxxmd/multi-scrobbler:latest";
    ports = [ "127.0.0.1:${port}:${port}" ];
    environmentFiles = [ config.age.secrets.multi-scrobbler-env.path ];
    volumes = [
      "/var/lib/multi-scrobbler/config:/config"
      "/var/lib/multi-scrobbler/logs:/logs"
    ];

    extraOptions = [ "--restart=no" ];
  };

  systemd.services."${config.virtualisation.oci-containers.containers.multi-scrobbler.serviceName}" =
    {
      restartTriggers = [
        (builtins.hashFile "sha256" ../../../secrets/multi_scrobbler_secrets.age)
      ];
    };

  services.caddy.virtualHosts."multi-scrobbler.j3ff.io".extraConfig = ''
    reverse_proxy http://127.0.0.1:${port}
  '';
}
