{ ... }:
{
  imports = [
    ../../home-manager
  ];

  modules = {
    device = {
      videoOutput = [
        "eDP-1"
        "DP-3"
      ];
      type = "handheld";
      tags = [
        "battery"
        "gaming"
        "lowSpec"
        "steamdeck"
        "touchscreen"
      ];
    };
    hm = {
      gaming.enable = true;
      browser.librewolf.enable = true;
      theme = {
        colorScheme = "gruvbox";
        wallpaper = "003";
      };
    };
  };
}
