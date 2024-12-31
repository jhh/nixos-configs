{
  osConfig,
  lib,
  ...
}:
{
  programs.starship = {
    enable = true;
    enableFishIntegration = true;
    settings = {
      add_newline = true;
      format = "$all";
      aws.disabled = true;
      python.format = "via [$symbol]($style)";
      nodejs.format = "via [$symbol]($style)";
    };

    settings.container.disabled = lib.elem osConfig.networking.hostName [
      "vesta"
      "eris"
      "ceres"
    ];
  };
}
