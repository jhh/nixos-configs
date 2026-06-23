{
  config,
  lib,
  pkgs,
  ...
}:

let
  # ── Customise these ──────────────────────────────────────────────
  plexDataDir = "${config.services.plex.dataDir}/Plex Media Server";
  backupDir = "/mnt/tank/backup/plex";
  keepDays = 7;
  backupTime = "02:30:00";
  # ─────────────────────────────────────────────────────────────────
in
{
  systemd = {
    # ── Backup service ───────────────────────────────────────────────
    services.plex-backup = {
      description = "Plex Media Server backup";

      # Stop Plex before backing up so the SQLite DB is in a consistent state,
      # then restart it afterwards.
      conflicts = [ "plex.service" ];
      after = [ "plex.service" ];

      # When this unit finishes (success or failure), trigger the restart unit
      onSuccess = [ "plex-restart.service" ];
      onFailure = [ "plex-restart.service" ];

      preStart = ''
        AM_URL="http://alertmanager.j3ff.io:${toString config.services.prometheus.alertmanager.port}"
        START=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
        END=$(date -u -d "+1 hours" +"%Y-%m-%dT%H:%M:%SZ")

        ${lib.getExe pkgs.curl} -X POST "$AM_URL/api/v2/silences" \
          -H "Content-Type: application/json" \
          -d '{
            "matchers": [
              {"name": "job", "value": "node", "isRegex": false},
              {"name": "instance", "value": "luna", "isRegex": false},
              {"name": "name", "value": "plex.service", "isRegex": false}
            ],
            "startsAt": "'$START'",
            "endsAt": "'$END'",
            "createdBy": "plex-backup",
            "comment": "Nightly backup window"
          }'
      '';

      script = ''
        set -euo pipefail

        TIMESTAMP=$(${pkgs.coreutils}/bin/date +"%Y-%m-%d_%H%M%S")
        DEST="${backupDir}/$TIMESTAMP"
        PLEX_SRC="${plexDataDir}"

        echo "==> Starting Plex backup at $TIMESTAMP"

        # Perform the backup (rsync for efficiency; excludes Cache, Logs, Crash Reports)
        ${pkgs.rsync}/bin/rsync -a --delete \
          --exclude='Cache/'          \
          --exclude='Logs/'           \
          --exclude='Crash Reports/'  \
          --exclude='Diagnostics/'    \
          "$PLEX_SRC/" "$DEST/"

        echo "==> Backup complete: $DEST"

        # Prune backups older than ${toString keepDays} days
        ${pkgs.findutils}/bin/find "${backupDir}" \
          -maxdepth 1 -mindepth 1 -type d \
          -mtime +${toString keepDays} \
          -exec ${pkgs.coreutils}/bin/rm -rf {} +

        echo "==> Old backups pruned (kept last ${toString keepDays} days)"
      '';

      serviceConfig = {
        Type = "oneshot";
        User = "root"; # needs access to plex data dir and backup dest
        RemainAfterExit = false;
      };
    };

    # ── Plex restart service ─────────────────────────────────────────
    # Runs after plex-backup exits (success or failure), fully outside
    # the backup unit's lifecycle so Conflicts= no longer applies.
    services.plex-restart = {
      description = "Restart Plex after backup";
      after = [ "plex-backup.service" ];

      script = ''
        echo "==> Restarting Plex Media Server"
        ${pkgs.systemd}/bin/systemctl start plex.service
      '';

      serviceConfig = {
        Type = "oneshot";
        User = "root";
      };
    };

    # ── Timer (daily at backupTime) ──────────────────────────────────
    timers.plex-backup = {
      description = "Daily Plex Media Server backup timer";
      wantedBy = [ "timers.target" ];

      timerConfig = {
        OnCalendar = "*-*-* ${backupTime}";
        Persistent = true; # run immediately if the last scheduled run was missed
        Unit = "plex-backup.service";
      };
    };
  };
}
