# common/darwin/default.nix
{ ... }:
{
  imports = [
    ./homebrew.nix
  ];

  security.pam.enableSudoTouchIdAuth = true;

  # system.defaults.dock = {
  #   autohide = false;
  #   mru-spaces = false;
  #   orientation = "left";
  # };

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
