{ config, lib, ... }: {

  boot = {
    initrd.kernelModules = [ "kvm-amd" ];
  };

  hardware.cpu.amd.updateMicrocode = true;

}
