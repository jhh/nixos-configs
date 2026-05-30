{ ... }:
{
  imports = [
    # ./explo.nix
    ./multi-scrobbler.nix
  ];

  virtualisation.oci-containers.backend = "podman";

  virtualisation.podman = {
    enable = true;
    defaultNetwork.settings.dns_enabled = true;

    autoPrune = {
      enable = true;
      flags = [ "--all" ];
    };
  };
}
