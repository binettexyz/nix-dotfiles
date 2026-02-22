{ inputs, ... }:
{
  flake.modules.homeManager.suzakuBinette = {
    imports = with inputs.self.modules.homeManager; [
      binettePkgsConfig
      consoleGamingPreset
      emulation
    ];

    modules = {
      device = {
        hostname = "suzaku";
        type = "desktop";
        tags = [
          "console"
          "workstation"
          "gaming"
          "highSpec"
        ];
        videoOutputs = [
          "HDMI-A-1"
          "HDMI-A-2"
        ];
        storage = {
          hdd = true;
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
