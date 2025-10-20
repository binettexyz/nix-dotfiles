{config, flake, lib, ...}: {
  imports = [
    ../../home-manager
  ];

  modules = {
    device = {
      tags = ["console" "workstation" "gaming" "highSpec"];
      type = "desktop";
      videoOutput = ["HDMI-A-1" "HDMI-A-2"];
      storage = {
        hdd = true;
        ssd = true;
      };
    };
    hm = {
      gaming.enable = true;
      gui.packages = true;
      browser.librewolf.enable = true;
      theme = {
        colorScheme = "gruvbox";
        wallpaper = "003";
      };
      hyprland = {
        exec-once = [
          "waybar &"
          "wl-paste --watch cliphist store &"
          "qutebrowser &"
          "steam &"
          "vesktop &"
        ];
        monitor = [
          "${lib.elemAt config.modules.device.videoOutput 0},1920x1080@179.981995,0x0,1"
        ];
        general = {
          sensitivity = 0;
          accel_profile = "custom";
        };
      };
    };
  };
}
