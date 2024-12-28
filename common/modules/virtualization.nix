{
  config,
  lib,
  pkgs,
  ...
}:
{
  options = {
    j3ff.virtualization.enable = lib.mkEnableOption "KVM virtualization support";
  };

  config = lib.mkIf config.j3ff.virtualization.enable {
    environment.systemPackages = with pkgs; [
      virt-manager
    ];

    virtualisation.libvirtd.enable = true;
  };
}
