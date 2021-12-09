{ config, ... }: {

  boot.kernelModules = [ "kvm-intel" ];
  hardware.cpu.intel.updateMicrocode = true;
  services.throttled.enable = false;

}
