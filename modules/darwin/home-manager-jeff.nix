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
  ];

  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
}
