{lib, ... }: {

    # swap ram when % bellow is reach (1-100)
  boot.kernel.sysctl = {
    "vm.swappiness" = 1;
  };

    # ssd trimming
  services.fstrim.enable = true;
}
