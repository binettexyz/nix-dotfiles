{ pkgs, config, lib, ... }:
with lib;

{
    services.flameshot = {
      enable = true;
      settings = {
        General = {
          disabledTrayIcon = true;
          showStartupLaunchMessage = false;
          savePath = "/home/binette/Pictures/screenshots";
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

}
