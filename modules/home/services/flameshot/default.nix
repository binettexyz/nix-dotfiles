{ pkgs, config, lib, ... }:
with lib;

let
  cfg = config.modules.services.flameshot;
in
{
  options.modules.services.flameshot = {
    enable = mkOption {
      description = "Enable flameshot service";
      type = types.bool;
      default = false;
    };
  };

  config = mkIf (cfg.enable) {
    services.flameshot = {
      enable = true;
      settings = {
        General = {
          disabledTrayIcon = true;
          showStartupLaunchMessage = false;
          savePath = "/home/binette/pictures/screenshots";
          savePathFixed = true;
          saveAsFileExtension = ".png";
          uiColor = "#458588";
          contrastUiColor = "#83a598";
          showHelp = false;
          showSidePanelButton = false;
          showDesktopNotification = true;
          startupLaunch = true;
          saveAfterCopy = true;
        };
      };
    };
  };
}
