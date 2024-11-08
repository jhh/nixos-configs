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
      logging = 0

      vfs objects = fruit streams_xattr
      fruit:metadata = stream
      fruit:model = MacSamba
      fruit:veto_appledouble = no
      fruit:nfs_aces = no
      fruit:wipe_intentionally_left_blank_rfork = yes
      fruit:delete_empty_adfiles = yes
      fruit:posix_rename = yes

      hosts allow = 10.1.0.0/24 100.64.0.0/10
      guest account = nobody
      map to guest = bad user

      load printers = no
    '';

    shares = {
      Jeff = {
        path = "/mnt/tank/share/jeff";
        "valid users" = "jeff";
        public = "no";
        writeable = "yes";
      };

      Lightroom = {
        path = "/mnt/tank/media/lightroom";
        "valid users" = "jeff";
        public = "no";
        writeable = "yes";
      };

      Music = {
        path = "/mnt/tank/media/plex/music/Music";
        public = "yes";
        writeable = "no";
      };

      ganymede = {
        path = "/mnt/tank/backup/tm/ganymede";
        "valid users" = "jeff";
        browsable = "no";
        public = "no";
        writeable = "yes";
        "fruit:time machine" = "yes";
      };


      callisto = {
        path = "/mnt/tank/backup/tm/callisto";
        "valid users" = "jeff";
        browsable = "no";
        public = "no";
        writeable = "yes";
        "fruit:time machine" = "yes";
      };

      TimeMachine = {
        path = "/mnt/tank/backup/tm/share";
        "valid users" = "jeff";
        "force user" = "jeff";
        public = "no";
        writeable = "yes";
        "fruit:aapl" = "yes";
        "fruit:time machine" = "yes";
        "vfs objects" = "catia fruit streams_xattr";
      };
    };
  };

  # Ensure Time Machine can discover the share without `tmutil`
  services.avahi = {
    extraServiceFiles = {
      timemachine = ''
        <?xml version="1.0" standalone='no'?>
        <!DOCTYPE service-group SYSTEM "avahi-service.dtd">
        <service-group>
          <name>Time Machine on Luna</name>
          <service>
            <type>_smb._tcp</type>
            <port>445</port>
          </service>
            <service>
            <type>_device-info._tcp</type>
            <port>0</port>
            <txt-record>model=TimeCapsule8,119</txt-record>
          </service>
          <service>
            <type>_adisk._tcp</type>
            <txt-record>dk0=adVN=TimeMachine,adVF=0x82</txt-record>
            <txt-record>sys=waMa=0,adVF=0x100</txt-record>
          </service>
        </service-group>
      '';
    };
  };

}
