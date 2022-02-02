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
  };

}
