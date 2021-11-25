{ config, pkgs, ... }: {

  services = {
      # enable x11 windowing system.
    xserver = {
      enable = true;
      layout = "us";
#      synaptics = {
#        enable = true;
#        accelFactor = "0.05";
#        fingersMap = [ 1 3 2 ];
#        twoFingerScroll = true;
#        horizontalScroll = true;
#        buttonsMap = [1 3 2];
#      };
      libinput = {
        enable = true;
        touchpad = {
          naturalScrolling = true;
          tapping = true;
          disableWhileTyping = true;
          middleEmulation = true;
        };
      };
      videoDrivers = [ "intel" ];
      displayManager.startx.enable = true;
      windowManager.dwm.enable = true;
    };
   };

}
