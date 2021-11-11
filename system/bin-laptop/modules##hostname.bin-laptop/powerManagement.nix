{config, pkgs, ... }: {

  services = {
    tlp.enable = true;
    thermald.enable = true;
    auto-cpufreq.enable = true;
  };
  powerManagement.powertop.enable = true;

}
