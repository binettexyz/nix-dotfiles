{ pkgs, ... }:
{
  programs.plasma = {
    enable = true;
    overrideConfig = true;
    workspace = {
      clickItemTo = "open";
      colorScheme = "BreezeDark";
      cursor = {
        theme = "Breeze_cursors";
        size = 24;
      };
      iconTheme = "breeze-dark";
      lookAndFeel = "org.kde.breezedark.desktop";
      theme = "breeze-dark";
      wallpaper = "${pkgs.kdePackages.plasma-workspace-wallpapers}/share/wallpapers/Mountain/contents/images_dark/5120x2880.png";
    };

    kscreenlocker.autoLock = false;

    panels = [
      {
        location = "bottom";
        alignment = "center";
        hiding = "none";
        floating = true;
        widgets = [
          {
            kickoff = {
              sortAlphabetically = true;
              icon = "nix-snowflake-white";
            };
          }
          {
            iconTasks = {
              launchers = [
                "applications:librewolf.desktop"
                "applications:org.kde.dolphin.desktop"
                "applications:org.kde.konsole.desktop"
                "applications:discord.desktop"
                "applications:steam.desktop"

              ];
              behavior = {
                showTasks = {
                  onlyInCurrentScreen = true;
                  onlyInCurrentDesktop = true;
                  onlyInCurrentActivity = true;
                };
              };
            };
          }
          {
            systemTray.items = {
              shown = [
                "org.kde.plasma.battery"
              ];
              hidden = [
                "org.kde.plasma.addons.katesessions"
              ];
              configs = {
                battery.showPercentage = true;
              };
            };
          }
          {
            digitalClock.time = {
              showSeconds = "always";
              format = "24h";
            };
            digitalClock.calendar = {
              firstDayOfWeek = "sunday";
              showWeekNumbers = true;
              plugins = [ "holidaysevents" ];
            };
          }
          "org.kde.plasma.showdesktop"
        ];
      }
    ];

    powerdevil.AC = {
      autoSuspend.action = "nothing";
      dimDisplay.enable = false;
      powerButtonAction = "sleep";
      powerProfile = "performance";
      turnOffDisplay.idleTimeout = "never";
    };

    configFile = {
      kcminputrc."Libinput/1133/50503/Logitech USB Receiver" = {
        PointerAccelerationProfile = 1;
        PointerAcceleration = -0.200;
      };
      kwinrc.Plugins.shakecursorEnabled = false;
    };

    dataFile = {
      #"dolphin/view_properties/global/.directory"."Dolphin"."SortRole" = "modificationtime";
      "dolphin/view_properties/global/.directory"."Dolphin"."ViewMode" = 1;
      "dolphin/view_properties/global/.directory"."Settings"."HiddenFilesShown" = true;
    };
  };
}
