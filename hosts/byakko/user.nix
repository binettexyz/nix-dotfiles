{flake, lib, osConfig, ...}: let
  output = osConfig.device.videoOutput;
in {
  imports = [
    ../../home-manager
    (flake.inputs.impermanence + "/home-manager.nix")
    flake.inputs.nix-colors.homeManagerModule
    flake.inputs.plasma-manager.homeManagerModules.plasma-manager
    #    flake.inputs.nixvim.homeManagerModules.nixvim
  ];

  modules.hm = {
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
        "qutebrowser &"
      ];
      monitor = [
        "${lib.elemAt output 0},1920x1080@60.0,0x1080,1.2"
        "${lib.elemAt output 1},1920x1080@179.981995,0x0,1"
      ];
    };
  };
}
