{ flake, ... }:
{
  imports = [
    flake.modules.darwin.default
    flake.modules.darwin.homebrew
    flake.modules.darwin.home-manager-jeff
  ];

  nixpkgs.hostPlatform = "aarch64-darwin";
  nix.linux-builder = {
    enable = true;
    ephemeral = true;
    maxJobs = 4;
    config = {
      virtualisation = {
        darwin-builder = {
          diskSize = 40 * 1024;
          memorySize = 8 * 1024;
        };
        cores = 6;
      };
    };
  };
  system.stateVersion = 4;
}
