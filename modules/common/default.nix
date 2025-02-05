{ ... }:
{
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.allowBroken = false;
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
}
