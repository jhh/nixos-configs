{ pkgs, ... }:
{
  home.file = {
    # ".config/raycast-scripts/play-wfuv" = sonosCommand "Play WFUV in Studio" "Studio play_favorite WFUV";
    ".config/raycast-scripts/play-wfuv" =
      let
        arg1 = builtins.toJSON {
          type = "dropdown";
          placeholder = "Speaker (Studio)";
          data = [
            {
              title = "Studio";
              value = "Studio";
            }
            {
              title = "Living Room";
              value = "Living Room";
            }
            {
              title = "Porch";
              value = "Porch";
            }
            {
              title = "Sonos Move";
              value = "Sonos Move";
            }
          ];
        };
      in
      {
        executable = true;
        text = ''
          #!${pkgs.runtimeShell} -eu
          # @raycast.title Play WFUV
          # @raycast.schemaVersion 1
          # @raycast.mode silent
          # @raycast.packageName Sonos Scripts
          # @raycast.icon ${./sonos.png}
          # @raycast.needsConfirmation false
          # @raycast.author Jeff Hutchison
          # @raycast.argument1 ${arg1}
          ${pkgs.soco-cli}/bin/sonos --use-local-speaker-list "$1" play_favorite WFUV
        '';
      };

    ".config/raycast-scripts/refresh-speaker-cache" = {
      executable = true;
      text = ''
        #!${pkgs.runtimeShell} -eu
        # @raycast.title Refresh Speaker Cache
        # @raycast.schemaVersion 1
        # @raycast.mode fullOutput
        # @raycast.packageName Sonos Scripts
        # @raycast.icon ${./sonos.png}
        # @raycast.needsConfirmation true
        # @raycast.author Jeff Hutchison
        ${pkgs.soco-cli}/bin/sonos-discover
      '';
    };
  };
}
