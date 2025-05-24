{osConfig, pkgs, ...}: {
  services.hyprpaper = {
    enable = osConfig.programs.hyprland.enable;
    settings = {
      preload = ["${pkgs.wallpapers.gruvbox}"];
      wallpaper = [
        "HDMI-A-1,${pkgs.wallpapers.gruvbox}"
        "eDP-1,${pkgs.wallpapers.gruvbox}"
      ];
    };
  };
}
