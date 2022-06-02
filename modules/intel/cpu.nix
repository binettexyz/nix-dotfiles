{ config, lib, ... }: {

        boot.initrd.kernelModules = [ "i915" ];
        boot.kernelModules = [ "kvm-intel" ];

        hardware.cpu.intel.updateMicrocode = true;
        services.throttled.enable = false;

}
