{ config, pkgs, ... }: {

  services = {
      # enable x11 windowing system.
    xserver = {
      enable = true;
      layout = "us";
      videoDrivers = [ "nvidia" ];
      displayManager.startx.enable = true;
      windowManager.dwm.enable = true;
    };
   };

}
