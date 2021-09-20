{config, lib, ...}:
{
  options = {
    j3ff.mdns = lib.mkOption {
      type = lib.types.bool;
      default = false;
    };
  };

  config = {
    networking.useHostResolvConf = false;
    services.resolved = {
      enable = true;
      dnssec = "false";
      llmnr = lib.boolToString config.j3ff.mdns;
      domains = [
        "lan.j3ff.io"
      ];
    };

    services.avahi = {
      enable = config.j3ff.mdns;
      nssmdns = true;
    };
  };
}
