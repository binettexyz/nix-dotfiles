{pkgs, ... }: {

  powerManagement = {
    enable = true;
  };

  services = {
    tlp = {
      enable = true;
      settings = {
          # Disable too aggressive power-management autosuspend for USB receiver for wireless mouse
        USB_AUTOSUSPEND = 0;
        START_CHARGE_THRESH_BAT0 = 90;
        STOP_CHARGE_THRESH_BAT0 = 95;
        START_CHARGE_THRESH_BAT1 = 90;
        STOP_CHARGE_THRESH_BAT1 = 95;
        CPU_SCALING_GOVERNOR_ON_AC = "performance";
        CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
        ENERGY_PERF_POLICY_ON_AC = "performance";
        ENERGY_PERF_POLICY_ON_BAT = "powersave";
        CPU_MIN_PERF_ON_AC = 0;
        CPU_MAX_PERF_ON_AC = 90;
        CPU_MIN_PERF_ON_BAT = 0;
        CPU_MAX_PERF_ON_BAT = 30;
      };
    };
    thermald.enable = true;
    auto-cpufreq.enable = true;
  };

  environment = {
    systemPackages = with pkgs; [
      powertop
      acpi
      tlp
    ];
  };

}
