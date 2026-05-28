{ config, ... }:
{
  virtualisation.oci-containers.backend = "podman";

  virtualisation.podman = {
    enable = true;
    defaultNetwork.settings.dns_enabled = true;

    # autoPrune = {
    #   enable = true;
    #   flags = [ "--all" ];
    # };
  };

  age.secrets.multi-scrobbler-env = {
    file = ../../secrets/multi_scrobbler_secrets.age;
  };

  virtualisation.oci-containers.containers = {

    multi-scrobbler = {
      image = "foxxmd/multi-scrobbler:latest";
      ports = [ "9078:9078" ];
      environmentFiles = [ config.age.secrets.multi-scrobbler-env.path ];
      volumes = [
        "/var/lib/multi-scrobbler/config:/config"
        "/var/lib/multi-scrobbler/logs:/logs"
      ];

      extraOptions = [ "--restart=no" ];
    };

    # Add more containers here...
  };
}
