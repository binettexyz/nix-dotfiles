{ lib, ... }: {

  services.xserver = {
    xrandrHeads = [
      { output = "HDMI1";
        primary = true;
        monitorConfig = ''
          Modeline "1920x1080_60.00"  173.00  1920 2048 2248 2576  1080 1083 1088 1120 -hsync +vsync
          Option "PreferredMode" "1920x1080_60.00"
          Option "Position" "1366 0"
        '';
      }
      { output = "eDP1";
        monitorConfig = ''
          Modeline "1368x768_60.11"   85.50  1368 1440 1576 1784  768 771 781 798 -hsync +vsync
          Option "PreferredMode" "1366x768_60.11"
          Option "Position" "0 0"
        '';
      }
    ];

  };
}
