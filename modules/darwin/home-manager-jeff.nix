{
  flake,
  inputs,
  pkgs,
  ...
}:
{
  imports = [
    inputs.home-manager.darwinModules.home-manager
  ];

  users.users.jeff = {
    name = "jeff";
    description = "Jeff Hutchison";
    home = "/Users/jeff";
    shell = pkgs.fish;
  };

  home-manager.users.jeff.imports = [
    flake.homeModules.jeff
    flake.homeModules.ghostty
    flake.homeModules.sonos
    ({
      j3ff.gui.ghostty.enable = true;
    })
  ];

  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
}
