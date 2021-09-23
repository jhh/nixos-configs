{ config, pkgs, ... }:
{
  services.samba = {
    enable = true;
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
      fruit:veto_appledouble = yes
      fruit:posix_rename = yes 
      fruit:zero_file_id = yes
      fruit:wipe_intentionally_left_blank_rfork = yes 
      fruit:delete_empty_adfiles = yes

      #use sendfile = yes
      hosts allow = 192.168.1.0/24
      guest account = nobody
      map to guest = bad user

      load printers = no
      printing = bsd
      printcap name = /dev/null  
      disable spoolss = yes
    '';

    shares = {
      tm_europa = {
        path = "/mnt/tank/backup/tm/europa";
        "valid users" = "jeff";
        public = "no";
        writeable = "yes";
        "force user" = "jeff";
        "fruit:time machine" = "yes";
      };

      tm_callisto = {
        path = "/mnt/tank/backup/tm/callisto";
        "valid users" = "jeff";
        public = "no";
        writeable = "yes";
        "force user" = "jeff";
        "fruit:time machine" = "yes";
      };
    };
  };

}
