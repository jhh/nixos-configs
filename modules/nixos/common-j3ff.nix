{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    inputs.agenix.nixosModules.default
  ];

  environment.systemPackages = with pkgs; [
    ghostty.terminfo
  ];

  nix = {
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 14d";
      randomizedDelaySec = "1h";
    };

    settings = {
      substituters = [
        "https://strykeforce.cachix.org"
      ];

      trusted-public-keys = [
        "strykeforce.cachix.org-1:+ux184cQfS4lruf/lIzs9WDMtOkJIZI2FQHfz5QEIrE="
      ];
    };
  };

  programs.fish.enable = true;

  security.sudo.wheelNeedsPassword = false;

  users.users.root = {
    # https://start.1password.com/open/i?a=7Z533SZAYZCNVL764G5INOV75Q&v=lwpxghrefna57cr6nw7mr3bybm&i=v6cyausjzre6hjypvdsfhlkbty&h=my.1password.com
    hashedPassword = "$y$j9T$6B8V0Z9VkFiU0fMwSuLrA0$z3YHuwwAZro3N7TopVIsNltIJ5BXt3TQj1wQqt5HSuD";
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPqpWpNJzfzioGYyR9q4wLwPkBrnmc/Gdl6JsO+SUpel jeff@j3ff.io"
    ];
  };

  users.users.jeff = lib.mkDefault {
    isNormalUser = true;
    createHome = false;
    useDefaultShell = false;
    uid = 1000;
  };

  users = {
    users.media = {
      uid = 994;
      group = "media";
      shell = pkgs.shadow;
      isSystemUser = true;
    };
    groups.media = {
      gid = 994;
    };
  };
}
