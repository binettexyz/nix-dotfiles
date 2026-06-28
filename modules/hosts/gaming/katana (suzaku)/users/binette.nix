{ inputs, ... }:
let
  host = "katana";
in
{
  flake.modules.homeManager."${host}Binette" =
    {
      lib,
      config,
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
          hostname = host;
          type = "desktop";
          tags = [
            "console"
            "workstation"
            "highSpec"
          ];
          videoOutputs = [
            "DP-1"
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
            ];
          };
        };
      };
    };
}
