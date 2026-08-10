{ inputs, ... }:
{
  flake.modules.homeManager.wakizashiBinette =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      imports = with inputs.self.modules.homeManager; [
        binetteShell
        binetteFoot
        binetteGit
        binetteLibrewolf
        binetteMpv
        binetteNeovim
        binetteTmux
        binetteYazi
        desktopGamingPreset
        emulation
      ];

      modules = {
        device = {
          hostname = "wakizashi";
          type = "handheld";
          tags = [
            "battery"
            "gaming"
            "lowSpec"
            "steamdeck"
            "touchscreen"
            "workstation"
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
          hyprland = {
            exec-once = [
              "waybar &"
              "wl-paste --watch cliphist store &"
              "foot --server"
            ];
            monitor = [
              "${lib.elemAt config.modules.device.videoOutputs 0},disabled"
              "${lib.elemAt config.modules.device.videoOutputs 1},3440x1440@99.98,0x0,1"
            ];
          };
        };
      };
      home.packages = [ pkgs.moonlight-qt ];
    };
}
