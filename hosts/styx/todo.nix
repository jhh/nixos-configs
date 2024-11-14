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

  services.nginx = {
    enable = true;
    recommendedProxySettings = true;
    recommendedOptimisation = true;
    recommendedGzipSettings = true;
    virtualHosts."todo.j3ff.io" = lib.mkIf config.services.todo.enable {
      locations = {
        "/" = {
          proxyPass = "http://127.0.0.1:8000";
        };
      };
    };
  };
}
