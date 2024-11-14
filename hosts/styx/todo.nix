{ config, pkgs, ... }: {

  age.secrets.todo_secrets = {
    file = ../../secrets/todo_secrets.age;
  };

  services.todo = {
    enable = true;
    secrets = [ config.age.secrets.todo_secrets.path ];
  };
}
