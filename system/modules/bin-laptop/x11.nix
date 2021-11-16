{ config, pkgs, ... }: {

  services = {
      # enable x11 windowing system.
    xserver = {
      enable = true;
      layout = "us";
      libinput = {
        enable = true;
        touchpad = {
          naturalScrolling = false;
          middleEmulation = true;
          tapping = true;
        };
      };
      videoDrivers = [ "intel" ];
      displayManager.startx.enable = true;
#      displayManager.sddm = {
#        enable = true;
#        theme = "simplicity";
#      };
      windowManager.dwm.enable = true;
    };
   };

}
