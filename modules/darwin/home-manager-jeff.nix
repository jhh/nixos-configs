{
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
    inputs.self.homeModules.jeff
    inputs.self.homeModules.ghostty
    inputs.self.homeModules.sonos
  ];

  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;

  home-manager.users.jeff.config.j3ff.gui.ghostty.enable = true;
}
