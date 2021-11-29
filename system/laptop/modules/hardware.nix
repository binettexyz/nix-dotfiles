{pkgs, config, ...}: {

    # touchpad
  services = {
    xserver = {
      synaptics = {
        enable = true;
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
        enable = false;
        touchpad = {
          naturalScrolling = true;
          tapping = true;
          disableWhileTyping = true;
          middleEmulation = true;
        };
      };
    };
      # ssd trimming
    fstrim = {
      enable = true;
      interval = "weekly";
    };
    throttled.enable = true;
  };

  hardware = {
      # trackpoint
    trackpoint = {
      enable = true;
      sensitivity = 220;
      speed = 220;
      emulateWheel = true;
    };
    enableRedistributableFirmware = true;
    cpu.intel.updateMicrocode = true;
    opengl = {
      enable = true;
      driSupport = true;
      driSupport32Bit = true;
    };
  };

}
