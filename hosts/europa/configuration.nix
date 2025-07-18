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
  networking.firewall.enable = true;

  i18n.defaultLocale = "en_US.UTF-8";

  hardware = {
    openrazer = {
      enable = true;
      users = [ "jeff" ];
    };
  };

  programs = {
    _1password.enable = false;
    _1password-gui = {
      enable = true;
      polkitPolicyOwners = [ "jeff" ];
    };

    chromium.enable = true;
    hyprland = {
      enable = true;
      withUWSM = true;
    };
    neovim = {
      enable = true;
      vimAlias = true;
    };
    ssh.startAgent = true;
  };

  nix = {
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

  nixpkgs.config.allowUnfree = true;

  environment.sessionVariables.NIXOS_OZONE_WL = "1";
  environment.systemPackages = with pkgs; [
    btop
    chromium
    curl
    fastfetch
    fd
    ghostty
    git
    gnumake
    hyprpolkitagent
    kitty
    mako
    razer-cli
    ripgrep
    spotify
    stow
    unzip
    waybar
    wget
    wl-clipboard
    wl-clip-persist
  ];

  services = {
    openssh.enable = true;
    hypridle.enable = true;
  };

  # Initial login experience
  services.greetd = {
    enable = true;
    settings.default_session.command = "${pkgs.greetd.tuigreet}/bin/tuigreet --remember --time --cmd \"uwsm start default\"";
  };

  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-emoji
    nerd-fonts.caskaydia-mono
  ];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "21.11"; # Did you read the comment?

}
