# common/darwin/default.nix
{ pkgs, ... }:
{

  programs.fish.enable = true;
  security.pam.services.sudo_local.touchIdAuth = true;

  nix = {
    extraOptions =
      ''
        auto-optimise-store = false # https://github.com/NixOS/nix/issues/7273
        experimental-features = nix-command flakes
      ''
      + pkgs.lib.optionalString (pkgs.system == "aarch64-darwin") ''
        extra-platforms = x86_64-darwin aarch64-darwin
      '';
    settings.trusted-users = [
      "root"
      "jeff"
    ];
    gc.automatic = true;
    gc.options = "--delete-older-than 14d";
    optimise.automatic = true;
  };

  system.defaults.CustomUserPreferences = {
    "com.microsoft.VSCode" = {
      "ApplePressAndHoldEnabled" = false;
    };
  };

  system.keyboard = {
    enableKeyMapping = true;
    remapCapsLockToControl = true;
  };

}
