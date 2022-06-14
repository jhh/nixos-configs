# common/darwin/default.nix
{ ... }:
{
  imports = [
    ./homebrew.nix
    ./sudo-touch.nix
  ];

  system.defaults.dock = {
    autohide = true;
    mru-spaces = false;
    orientation = "left";
  };


  system.keyboard = {
    enableKeyMapping = true;
    remapCapsLockToControl = true;
  };

}
