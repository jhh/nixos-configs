{
  flake,
  ...
}:
{
  imports = [
    flake.modules.nixos.hardware-proxmox-lxc
    flake.modules.nixos.j3ff-server
    flake.modules.nixos.jeff
    ./media.nix
  ];

  networking.hostName = "ceres";
  nixpkgs.hostPlatform = "x86_64-linux";

  nixpkgs.config.permittedInsecurePackages = [
    "aspnetcore-runtime-wrapped-6.0.36"
    "aspnetcore-runtime-6.0.36"
    "dotnet-sdk-wrapped-6.0.428"
    "dotnet-sdk-6.0.428"
  ];
  system.stateVersion = "23.11";
}
