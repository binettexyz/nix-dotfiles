{flake, lib, osConfig, ...}:
let
  output = osConfig.device.videoOutput;
in {
  imports = [
    ../../home-manager
    (flake.inputs.impermanence + "/home-manager.nix")
    flake.inputs.nix-colors.homeManagerModule
    flake.inputs.plasma-manager.homeModules.plasma-manager
  ];

  modules.hm = {
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
        "${lib.elemAt output 0},1920x1080@179.981995,0x0,1"
      ];
      general.input = {
        sensitivity = 0;
        accel_profile = "custom";
      };
    };
  };
}
