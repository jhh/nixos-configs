{ ... }:
{
  nixpkgs.config = {
    allowUnfree = true;
    allowBroken = false;
  };

  nix = {
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 14d";
      randomizedDelaySec = "1h";
    };

    settings = {
      substituters = [
        "https://strykeforce.cachix.org"
      ];

      trusted-public-keys = [
        "strykeforce.cachix.org-1:+ux184cQfS4lruf/lIzs9WDMtOkJIZI2FQHfz5QEIrE="
      ];
    };
  };
}
