{config, pkgs, ... }: {

  services = {
    tlp.enable = true;
    thermald.enable = true;
    auto-cpufreq.enable = true;
  };
     # usb ports are idle after a moment
#  powerManagement = {
#    powertop.enable = true;
#  };

}
