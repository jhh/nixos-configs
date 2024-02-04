{ config, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      ./rsync.nix
    ];

  networking.hostName = "titan";

  j3ff = {
    mail.enable = true;
    man.enable = true;
    mdns.enable = true;
  };

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  virtualisation.vmware.guest.enable = true;

  services = {
    fstrim.enable = true;
  };

  virtualisation.docker.enable = true;

  fileSystems."/host" = {
    fsType = "fuse./run/current-system/sw/bin/vmhgfs-fuse";
    device = ".host:/";
    options = [
      "umask=22"
      "uid=1000"
      "gid=100"
      "allow_other"
      "auto_unmount"
      "defaults"
    ];
  };


  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?
}
