{ pkgs, lib, ... }: {


  services.xserver = {
    synaptics = {
      enable = false;
      accelFactor = "0.035";
      fingersMap = [ 1 3 2 ];
      twoFingerScroll = true;
      horizontalScroll = true;
      buttonsMap = [1 3 2];
      palmDetect = true;
      additionalOptions = ''
        Option "TouchpadOff" "0"
        Option "LockedDrags" "1"
        Option "LockedDragTimeout" "200"
        Option "TapAndDragGesture" "1"
      '';
    };
    libinput = {
      enable = true;
      touchpad = {
        naturalScrolling = true;
        tapping = true;
        disableWhileTyping = true;
        middleEmulation = true;
      };
    };
  };
  hardware = {
      # trackpoint
    trackpoint = {
      enable = true;
      sensitivity = 300;
      speed = 128;
      emulateWheel = false;
    };
  };
}
