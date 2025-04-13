{
  config,
  lib,
  pkgs,
  ...
}:
{
  age.secrets.pbs_gembrit = {
    file = ../../secrets/pbs_gembrit.age;
  };

  environment.etc.".pxarexclude".text = ''
    **/*
    !group
    !machine-id
    !passwd
    !subgid
  '';

  systemd.services.pbs-backup = {
    startAt = "daily";

    serviceConfig = {
      EnvironmentFile = config.age.secrets.pbs_gembrit.path;
      ExecStart = ''
        ${lib.getExe pkgs.proxmox-backup-client} backup \
          strykeforce.pxar:/mnt/tank/share/strykeforce \
          nixos.pxar:/var/lib/nixos \
          etc.pxar:/etc \
          --ns daily
      '';
    };
  };

}
