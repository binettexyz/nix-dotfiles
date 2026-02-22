{ inputs, ... }:
{
  flake.modules.homeManager.byakkoBinette =
    {
      config,
      lib,
      ...
    }:
    {
      imports = with inputs.self.modules.homeManager; [
        binettePkgsConfig
        graphicalPreset
      ];

      modules = {
        device = {
          hostname = "byakko";
          type = "laptop";
          tags = [
            "workstation"
            "dev"
            "battery"
            "lowSpec"
          ];
          videoOutputs = [
            "eDP-1"
            "HDMI-A-2"
          ];
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
              "librewolf &"
            ];
            monitor = [
              "${lib.elemAt config.modules.device.videoOutputs 0},1920x1080@60.0,0x1080,1.2"
              "${lib.elemAt config.modules.device.videoOutputs 1},1920x1080@60.0,0x0,1"
            ];
          };
        };
      };
      home.username = "binette";
      home.packages = [ ];
    };
}
