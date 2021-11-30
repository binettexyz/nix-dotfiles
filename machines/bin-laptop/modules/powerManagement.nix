{config, pkgs, ... }: {

  services = {
    tlp = {
      enable = true;
      settings = {
        START_CHARGE_THRESH_BAT0 = 90;
        STOP_CHARGE_THRESH_BAT0 = 95;
        CPU_SCALING_GOVERNOR_ON_AC = "performance";
        ENERGY_PERF_POLICY_ON_AC = "performance";
        CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
        ENERGY_PERF_POLICY_ON_BAT = "powersave";
        CPU_MIN_PERF_ON_AC = 0;
        CPU_MAX_PERF_ON_AC = 100;
        CPU_MIN_PERF_ON_BAT = 0;
        CPU_MAX_PERF_ON_BAT = 30;
      };
#      extraConfig = ''
#        START_CHARGE_THRESH_BAT0=90
#        STOP_CHARGE_THRESH_BAT0=95
#        CPU_SCALING_GOVERNOR_ON_BAT=powersave
#        ENERGY_PERF_POLICY_ON_BAT=powersave
#        CPU_SCALING_GOVERNOR_ON_AC=balance-performance
#        ENERGY_PERF_POLICY_ON_AC=balance-performance
#      '';
    };
    thermald.enable = true;
    auto-cpufreq.enable = true;
  };
     # usb ports are idle after a moment
#  powerManagement = {
#    powertop.enable = true;
#  };

}
