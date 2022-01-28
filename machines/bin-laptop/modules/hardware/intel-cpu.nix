{ config, lib, ... }: {

# intel i5 ***

  boot = {
    initrd.kernelModules = [ "i915" ];
    kernelModules = [ "kvm-intel" ];
  };

  hardware.cpu.intel.updateMicrocode = true;
    # Limit nix jobs to match number of cpu cores.
  nix.maxJobs = 4;
  services.throttled.enable = false;

}
