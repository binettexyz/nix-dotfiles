{osConfig, ...}: {
  services.hyprpaper = {
    enable = osConfig.programs.hyprland.enable;
    settings = {
      preload = ["/home/binette/pictures/wallpapers/gruvbox/004.jpg"];
      wallpaper = ["HDMI-A-1,/home/binette/pictures/wallpapers/gruvbox/004.jpg"];
    };
  };
}
