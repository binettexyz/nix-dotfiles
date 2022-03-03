{ pkgs, ... }: {

  # AMD Radeon rx6600

    # driver
  boot.initrd.kernelModules = [ "amdgpu" ];
  services.xserver.videoDrivers = [ "amdgpu" ];

    # vulkan
  hardware.opengl = {
    driSupport = true;
      # For 32 bit applications
    driSupport32Bit = true;
    extraPackages = with pkgs; [
      rocm-opencl-icd
      rocm-opencl-runtime
      amdvlk
    ];
    extraPackages32 = with pkgs; [
      driversi686Linux.amdvlk
    ];
  };

}
