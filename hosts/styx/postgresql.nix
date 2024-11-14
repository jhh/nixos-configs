{ config, pkgs, ... }: {

  services.postgresql = {
    enable = true;
    package = pkgs.postgresql_16;
    ensureDatabases = [ "todo" ];
    ensureUsers = [
      {
        name = "todo";
        ensureDBOwnership = true;
      }
    ];
  };
}
