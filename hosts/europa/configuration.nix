{
  config,
  flake,
  pkgs,
  ...
}:

{
  imports = [
    ./hardware-configuration.nix
    flake.modules.nixos.home-manager-jeff
  ];

  # ZFS boot settings.
  boot.supportedFilesystems = [ "zfs" ];
  boot.zfs.devNodes = "/dev/";

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Set your time zone.
  time.timeZone = "America/Detroit";

  networking.hostName = "europa";
  networking.wireless.enable = true; # Enables wireless support via wpa_supplicant.
  networking.hostId = "88c43f5a";
  # networking.useDHCP = false;
  # networking.interfaces.eno1.useDHCP = true;
  # networking.interfaces.wlp58s0.useDHCP = true;

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  programs.hyprland.enable = true;
  programs.hyprland.withUWSM = true;
  programs.chromium.enable = true;
  programs.neovim.enable = true;
  programs.neovim.vimAlias = true;
  programs.ssh.startAgent = true;
  programs.fish.enable = true;

  nix = {
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  users.users.jeff = {
    isNormalUser = true;
    uid = 1000;
    home = "/home/jeff";
    description = "Jeff Hutchison";
    extraGroups = [
      "docker"
      "wheel"
    ];
    hashedPassword = "$6$Iz7OA82lRmO$6SqGFySdF4gr8U47sIY6Vf.WzVJjtrZ4hiGQ1OPCpksEvj4Uo5.ylfI1czif0o488BcHXGIlDIpnJY3kIgQeT0";
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPqpWpNJzfzioGYyR9q4wLwPkBrnmc/Gdl6JsO+SUpel jeff@j3ff.io"
    ];
  };

  users.users.root = {
    # https://start.1password.com/open/i?a=7Z533SZAYZCNVL764G5INOV75Q&v=lwpxghrefna57cr6nw7mr3bybm&i=v6cyausjzre6hjypvdsfhlkbty&h=my.1password.com
    hashedPassword = "$6$fQkrR0Y/UOZ7$RG1ARltUwRE2Q/zSM88en2KNpx2gDfzV/PSqjCq/c3njspl62.h6HFPnk1L.b8UvSWnxvoew/r79/CxwfzUYW1";
    openssh.authorizedKeys.keys = config.users.users.jeff.openssh.authorizedKeys.keys;
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
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

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "21.11"; # Did you read the comment?

}
