{
  config,
  flake,
  pkgs,
  ...
}:

{
  imports = [
    ./hardware-configuration.nix
    flake.modules.nixos.common-j3ff
    flake.modules.nixos.home-manager-jeff
  ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Set your time zone.
  time.timeZone = "America/Detroit";

  networking.hostName = "europa";
  networking.wireless.enable = true; # Enables wireless support via wpa_supplicant.

  i18n.defaultLocale = "en_US.UTF-8";

  programs.hyprland.enable = true;
  programs.hyprland.withUWSM = true;
  programs.chromium.enable = true;
  programs.neovim.enable = true;
  programs.neovim.vimAlias = true;
  programs.ssh.startAgent = true;

  nix = {
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

  environment.sessionVariables.NIXOS_OZONE_WL = "1";
  environment.systemPackages = with pkgs; [
    brave
    btop
    curl
    fastfetch
    fd
    firefox
    gcc
    git
    gnumake
    kitty
    ripgrep
    unzip
    wget
    wl-clipboard
  ];

  # ZFS maintenance settings.
  services.zfs.trim.enable = true;
  services.zfs.autoScrub.enable = true;
  services.zfs.autoScrub.pools = [ "rpool" ];

  services.openssh.enable = true;

  networking.firewall.enable = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "21.11"; # Did you read the comment?

}
