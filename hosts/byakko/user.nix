{config, lib, ...}: {
  imports = [
    ../../home-manager
  ];


  modules = {
    device = {
      videoOutput = ["eDP-1" "HDMI-A-2"];
      type = "laptop";
      tags = ["workstation" "dev" "battery" "lowSpec"];
    };
    hm = {
      browser = {
        librewolf.enable = true;
        qutebrowser.enable = true;
      };
      mpv.enable = true;
      theme = {
        colorScheme = "gruvbox";
        wallpaper = "003";
      };
      hyprland = {
        exec-once = [
          "waybar &"
          "wl-paste --watch cliphist store &"
          "qutebrowser &"
        ];
        monitor = [
          "${lib.elemAt config.modules.device.videoOutput 0},1920x1080@60.0,0x1080,1.2"
          "${lib.elemAt config.modules.device.videoOutput 1},1920x1080@60.0,0x0,1"
        ];
      };
    };
  };

}
