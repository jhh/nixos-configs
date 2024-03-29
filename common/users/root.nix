# common/users/root.nix

{ config, pkgs, ... }:

{
  users.users.root = {
    # https://start.1password.com/open/i?a=7Z533SZAYZCNVL764G5INOV75Q&v=lwpxghrefna57cr6nw7mr3bybm&i=v6cyausjzre6hjypvdsfhlkbty&h=my.1password.com
    hashedPassword = "$y$j9T$6B8V0Z9VkFiU0fMwSuLrA0$z3YHuwwAZro3N7TopVIsNltIJ5BXt3TQj1wQqt5HSuD";
    openssh.authorizedKeys.keys = config.users.users.jeff.openssh.authorizedKeys.keys;
  };

  home-manager.users.root = {
    programs.bash.enable = true;
    home.stateVersion = "22.05";
  };
}
