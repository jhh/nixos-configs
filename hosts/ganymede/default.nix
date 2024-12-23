{ config, pkgs, ... }:

{
  imports =
    [
      ../../common/darwin
    ];

  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = with pkgs; [
    _1password-cli
    coreutils
    findutils
    just
  ];

  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;

  security.pam.enableSudoTouchIdAuth = true;

  nix = {
    extraOptions = ''
      auto-optimise-store = false # https://github.com/NixOS/nix/issues/7273
      experimental-features = nix-command flakes
    '' + pkgs.lib.optionalString (pkgs.system == "aarch64-darwin") ''
      extra-platforms = x86_64-darwin aarch64-darwin
    '';
    settings.trusted-users = [ "root" "jeff" ];
    gc.automatic = true;
    gc.options = "--delete-older-than 14d";
    optimise.automatic = true;
  };

  # Create /etc/bashrc that loads the nix-darwin environment.
  # programs.zsh.enable = true;  # default shell on catalina
  programs.fish.enable = true;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;

  environment.shells = [ pkgs.fish ];

  users.users.jeff = {
    name = "jeff";
    home = "/Users/jeff";
    shell = pkgs.fish;
  };
}
