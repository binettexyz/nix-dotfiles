{ inputs, ... }:
{
  flake.modules.homeManager.keiBinette =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      imports = with inputs.self.modules.homeManager; [
        binettePkgsConfig
        graphicalPreset
      ];

      modules = {
        device = {
          hostname = "kei";
          type = "laptop";
          tags = [
            "workstation"
            "dev"
            "battery"
            "lowSpec"
          ];
          videoOutputs = [ "eDP-1" ];
        };
        hm = {
          browser = {
            qutebrowser.enable = true;
          };
          mpv.enable = false;
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
      home.username = "binette";
      home.packages = [ ];
    };
}
