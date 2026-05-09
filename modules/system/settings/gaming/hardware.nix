{
  flake.nixosModules.gamingController = {
    # ---Drivers---
    hardware.xpadneo.enable = true; # Xbox One Controller

    # ---Udev Rules---
    # https://github.com/ValveSoftware/steam-devices/blob/master/60-steam-input.rules
    services.udev = {
      extraRules = ''
        # ---Controllers--- #
        # Valve USB devices
        SUBSYSTEMS=="usb", ATTRS{idVendor}=="28de", MODE="0660", TAG+="uaccess"
        # Steam Controller udev write access
        KERNEL=="uinput", SUBSYSTEM=="misc", TAG+="uaccess", OPTIONS+="static_node=uinput"
        # Valve HID devices over USB hidraw
        KERNEL=="hidraw*", ATTRS{idVendor}=="28de", MODE="0660", TAG+="uaccess"
        # Valve HID devices over bluetooth hidraw
        KERNEL=="hidraw*", KERNELS=="*28DE:*", MODE="0660", TAG+="uaccess"
        # Allow wakeup from Valve devices (Steam Controller 2015 receiver, Steam Controller 2026 receiver, Steam Machine Bluetooth)
        ACTION=="add", SUBSYSTEM=="usb", ATTRS{idVendor}=="28de", ATTR{power/wakeup}="enabled"
        # PS5 DualSense controller over USB hidraw
        KERNEL=="hidraw*", ATTRS{idVendor}=="054c", ATTRS{idProduct}=="0ce6", MODE="0660", TAG+="uaccess"
        # PS5 DualSense controller over bluetooth hidraw
        KERNEL=="hidraw*", KERNELS=="*054C:0CE6*", MODE="0660", TAG+="uaccess"

        # Disable PS5 DualSense controller touchpad being recognized as a trackpad
        ACTION=="add|change", KERNEL=="event[0-9]*", ATTRS{name}=="*Wireless Controller Touchpad", ENV{LIBINPUT_IGNORE_DEVICE}="1"

        # ---Keyboards--- #
        # Keychron keyboard acces from webapp
        KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="3434", ATTRS{idProduct}=="0c10", MODE="0660", GROUP="binette", TAG+="uaccess", TAG+="udev-acl"
      '';
    };
  };
}
