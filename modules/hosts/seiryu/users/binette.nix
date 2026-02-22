{ inputs, ... }:
{
  flake.modules.homeManager.seiryuBinette = {
    imports = with inputs.self.modules.homeManager; [
      binettePkgsConfig
      consoleGamingPreset
      emulation
    ];

    modules = {
      device = {
        hostname = "seiryu";
        type = "handheld";
        tags = [
          "battery"
          "gaming"
          "lowSpec"
          "steamdeck"
          "touchscreen"
        ];
        videoOutputs = [
          "eDP-1"
          "DP-3"
        ];
        storage = {
          ssd = true;
        };
      };
      hm = {
        browser.librewolf.enable = true;
        theme = {
          colorScheme = "gruvbox";
          wallpaper = "003";
        };
      };
    };
  };
}
