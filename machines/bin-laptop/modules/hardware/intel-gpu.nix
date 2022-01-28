{ pkgs, ... }: {

  services.xserver.videoDrivers = [ "intel" ];

  hardware = {
    enableRedistributableFirmware = true;
    opengl = {
      enable = false;
      driSupport = true;
      driSupport32Bit = true;
      extraPackages = with pkgs; [
        vaapiIntel
        vaapiVdpau
        libvdpau-va-gl
        intel-media-driver
      ];
    };
  };

}
