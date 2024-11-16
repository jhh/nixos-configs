{ config, lib, pkgs, ... }: {

  age.secrets.todo_secrets = {
    file = ../../secrets/todo_secrets.age;
  };

  services.todo = {
    enable = true;
    secrets = [ config.age.secrets.todo_secrets.path ];
  };

  services.postgresql = lib.mkIf config.services.todo.enable {
    ensureDatabases = [ "todo" ];
    ensureUsers = [
      {
        name = "todo";
        ensureDBOwnership = true;
      }
    ];
  };

  systemd.services.postgresql.postStart = lib.mkIf config.services.todo.enable ''
    $PSQL -d todo -tA << END_INPUT
      ALTER DATABASE todo SET client_encoding TO 'UTF8';
      ALTER DATABASE todo SET default_transaction_isolation TO 'read committed';
      ALTER DATABASE todo SET timezone TO 'UTC';
    END_INPUT
  '';

  services.nginx = lib.mkIf config.services.todo.enable {
    enable = true;
    recommendedProxySettings = true;
    recommendedOptimisation = true;
    recommendedGzipSettings = true;
    virtualHosts."todo.j3ff.io" = {
      locations = {
        "/" = {
          proxyPass = "http://127.0.0.1:8000";
        };
      };
    };
  };
}
