# common/users/jeff.nix

{ flakes, config, pkgs, ... }:

{
  users.users.jeff = {
    isNormalUser = true;
    uid = 1000;
    shell = pkgs.fish;
    home = "/home/jeff";
    description = "Jeff Hutchison";
    extraGroups = [ "docker" "wheel" ];
    hashedPassword = "$6$Iz7OA82lRmO$6SqGFySdF4gr8U47sIY6Vf.WzVJjtrZ4hiGQ1OPCpksEvj4Uo5.ylfI1czif0o488BcHXGIlDIpnJY3kIgQeT0";
    openssh.authorizedKeys.keys = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPqpWpNJzfzioGYyR9q4wLwPkBrnmc/Gdl6JsO+SUpel jeff@j3ff.io" ];
  };

  home-manager.users.jeff = {
    imports = [ ../home-manager ];
  };
}
