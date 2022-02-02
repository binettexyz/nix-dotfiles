{ config, lib, ... }: {

  # AMD Ryzen 5 3600

  boot = {
    initrd.kernelModules = [ "i915" ];
  };

  hardware.cpu.amd.updateMicrocode = true;
    # Limit nix jobs to match number of cpu cores.
  nix.maxJobs = 6;

}
