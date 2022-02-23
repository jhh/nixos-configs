{ config, pkgs, ... }:
{

  users.users.tm = {
    isSystemUser = true;
    group = "tm";
    description = "Time Machine";
  };
  users.groups.tm = { };

  services.samba = {
    enable = true;
    securityType = "user";
    extraConfig = ''
      workgroup = WORKGROUP
      server string = Luna
      netbios name = LUNA
      security = user 
      min protocol = SMB2
      ea support = yes

      vfs objects = fruit streams_xattr
      fruit:aapl = yes
      fruit:metadata = stream
      fruit:model = MacSamba
      fruit:veto_appledouble = no
      fruit:posix_rename = yes 
      fruit:zero_file_id = yes
      fruit:wipe_intentionally_left_blank_rfork = yes 
      fruit:delete_empty_adfiles = yes

      use sendfile = yes
      socket options = IPTOS_LOWDELAY TCP_NODELAY
      hosts allow = 192.168.1.0/24
      guest account = nobody
      map to guest = bad user

      load printers = no
      printing = bsd
      printcap name = /dev/null  
      disable spoolss = yes
    '';

    shares = {
      Jeff = {
        path = "/mnt/tank/share/jeff";
        "valid users" = "jeff";
        public = "no";
        writeable = "yes";
        "force user" = "jeff";
      };

      tm_europa = {
        path = "/mnt/tank/backup/tm/europa";
        "valid users" = "jeff";
        browsable = "no";
        public = "no";
        writeable = "yes";
        "force user" = "jeff";
        "fruit:time machine" = "yes";
      };

      tm_callisto = {
        path = "/mnt/tank/backup/tm/callisto";
        "valid users" = "tm";
        browsable = "no";
        public = "no";
        writeable = "yes";
        "force user" = "tm";
        "fruit:time machine" = "yes";
      };
    };
  };

}
