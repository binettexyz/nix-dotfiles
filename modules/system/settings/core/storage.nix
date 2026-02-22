{
  flake.nixosModules.storage = {
    services.fstrim = {
      enable = true;
      interval = "weekly";
    };

    # Set I/O scheduler
    # kyber is set for NVMe, since scheduler doesn't make much sense on it
    # bfq for SATA SSDs/HDDs
    services.udev.extraRules = ''
      # set scheduler for NVMe
      ACTION=="add|change", KERNEL=="nvme[0-9]*", ATTR{queue/scheduler}="kyber"
      # set scheduler for SSD and eMMC
      ACTION=="add|change", KERNEL=="sd[a-z]|mmcblk[0-9]*", ATTR{queue/rotational}=="0", ATTR{queue/scheduler}="bfq"
      # set scheduler for rotating disks
      ACTION=="add|change", KERNEL=="sd[a-z]", ATTR{queue/rotational}=="1", ATTR{queue/scheduler}="bfq"
    '';
  };
}
