{ config, lib, ... }: {

  boot = {
    initrd.kernelModules = [ "i915" ];
    kernelModules = [ "kvm-intel" ];
  };

  hardware.cpu.intel.updateMicrocode = true;
  services.throttled.enable = false;

}
