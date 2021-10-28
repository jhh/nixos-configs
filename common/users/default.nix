# common/users/default.nix

{ flakes, config, pkgs, ... }:

{
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = { inherit flakes; };
    users = {
      jeff = {
        imports = [
          ../../home
        ];
      };
    };
  };

  users = {
    mutableUsers = false;
    users = {
      jeff = {
        isNormalUser = true;
        uid = 1000;
        shell = pkgs.fish;
        home = "/home/jeff";
        description = "Jeff Hutchison";
        extraGroups = [ "wheel" ];
        openssh.authorizedKeys.keys = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPqpWpNJzfzioGYyR9q4wLwPkBrnmc/Gdl6JsO+SUpel jeff@j3ff.io" ];
      };

      root = {
        # https://start.1password.com/open/i?a=7Z533SZAYZCNVL764G5INOV75Q&v=lwpxghrefna57cr6nw7mr3bybm&i=v6cyausjzre6hjypvdsfhlkbty&h=my.1password.com
        hashedPassword = "$6$fQkrR0Y/UOZ7$RG1ARltUwRE2Q/zSM88en2KNpx2gDfzV/PSqjCq/c3njspl62.h6HFPnk1L.b8UvSWnxvoew/r79/CxwfzUYW1";
        openssh.authorizedKeys.keys = config.users.users.jeff.openssh.authorizedKeys.keys;
      };
    };
  };
}
