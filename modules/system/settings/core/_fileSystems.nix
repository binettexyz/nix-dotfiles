{
  flake.nixosModules.fileSystems = {
    fileSystems = {
      "/" = {
        device = "none";
        fsType = "tmpfs";
        options = [
          "defaults"
          "size=2G"
          "mode=755"
        ];
      };

      #      "/nix" = {
      #        device = "/dev/disk/by-label/nix";
      #        fsType = "ext4";
      #      };

      "/boot" = {
        device = "/dev/disk/by-label/boot";
        fsType = "vfat";
        options = [
          "fmask=0022"
          "dmask=0022"
        ];
      };
    };

    swapDevices = [ { device = "/dev/disk/by-label/swap"; } ];
  };
}
