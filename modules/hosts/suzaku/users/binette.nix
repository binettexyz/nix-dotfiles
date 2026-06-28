{ inputs, ... }:
{
  flake.modules.homeManager.suzakuBinette =
    {
      lib,
      config,
      pkgs,
      ...
    }:
    {
      imports = with inputs.self.modules.homeManager; [
        binetteShell
        binetteLibrewolf
        binetteMpv
        binetteYazi
        binetteNeovim
        binetteFoot
        binetteGit
        binetteTmux
        desktopGamingPreset
        emulation
        gaming
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
            "DP-1"
            "HDMI-A-1"
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
          hyprland = {
            exec-once = [
              "waybar &"
              "wl-paste --watch cliphist store &"
              "librewolf &"
            ];
            monitor = [
              "${lib.elemAt config.modules.device.videoOutputs 0}, 3440x1440@165, 0x0, 1" # , cm, wide"
              "${lib.elemAt config.modules.device.videoOutputs 1}, disable"
            ];
          };
        };
      };
    };
}
