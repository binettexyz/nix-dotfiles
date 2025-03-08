{ lib, ... }: {

  imports = [ ./modules ];

  /* ---Custom Modules--- */
  device.type = "gaming-handheld";
  modules.gaming = {
    enable = true;
    steam.enable = true;
  };
  modules.system = {
    audio.enable = true;
    desktopEnvironment.jovian-nixos.enable = true;
    home.enable = true;
  };

  /* ---System Configuration--- */
  services.logind.powerKey = lib.mkForce "ignore";
    # Don't mount /tmp to tmpfs since there's not enough space to build valve kernel.
    # Instead, bind it into home. See "host/gyorai/hardware.nix".
  boot.tmp.useTmpfs = lib.mkForce false;
    # Enable plymouth
  boot.plymouth.enable = lib.mkForce true;
  boot.kernelParams = [ "splash" ];

  /* ---Performance tweaks based on CryoUtilities--- */
    # Determines how aggressively the kernel swaps out memory.
  boot.kernel.sysctl."vm.swappiness" = lib.mkForce 1;
    # Determines how aggressive memory compaction is done in the background.
  boot.kernel.sysctl."vm.compaction_proactiveness" = 0;
    # Determines the number of times that the page lock can be stolen from under a waiter before "fair" behavior kicks in.
  boot.kernel.sysctl."vm.page_lock_unfairness" = 1;
    # Hugepages
  systemd.tmpfiles.settings."10-gradientos-hugepages.conf" = {
      # Whether to enable hugepages.
    "/sys/kernel/mm/transparent_hugepage/enabled".w = {
      argument = "always";
    };
      # Whether to enable khugepaged defragmentation.
    "/sys/kernel/mm/transparent_hugepage/khugepaged/defrag".w = {
      argument = "0";
    };
      # Determines the hugepage allocation policy for the internal shmem mount.
    "/sys/kernel/mm/transparent_hugepage/shmem_enabled".w = {
      argument = "advise";
    };
  };
}
