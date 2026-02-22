{ inputs, ... }:
{
  flake.nixosModules.gaming =
    { pkgs, lib, ... }:
    {
      imports = [
        inputs.chaotic.nixosModules.default
      ]
      ++ (with inputs.self.nixosModules; [
        gamingController
        steam
      ]);

      #boot.kernelPackages = lib.mkForce pkgs.linuxPackages_cachyos;
      boot.kernelPackages = lib.mkForce pkgs.linuxPackages_jovian;

      # ---System Configuration---
      # Don't mount /tmp to tmpfs since there's not enough space to build valve kernel.
      # Instead, bind it into home. See "host/gyorai/hardware.nix".
      boot.tmp.useTmpfs = lib.mkForce false;
      boot.plymouth.enable = true; # Enable plymouth.
      # Needed for some **legit** games to run with lutris/wine.
      boot.kernelParams = [ "clearcpuid=512" ];

      # ---Performance Tweaks Based On CryoUtilities---
      # Determines how aggressively the kernel swaps out memory.
      boot.kernel.sysctl."vm.swappiness" = lib.mkForce 1;
      # Determines how aggressive memory compaction is done in the background.
      boot.kernel.sysctl."vm.compaction_proactiveness" = 0;
      # Determines the number of times that the page lock can be stolen from under a waiter before "fair" behavior kicks in.
      boot.kernel.sysctl."vm.page_lock_unfairness" = 1;
      systemd.tmpfiles.settings."10-gradientos-hugepages.conf" = {
        # Hugepages
        "/sys/kernel/mm/transparent_hugepage/enabled".w = {
          argument = "always"; # Whether to enable hugepages.
        };
        "/sys/kernel/mm/transparent_hugepage/khugepaged/defrag".w = {
          argument = "0"; # Whether to enable khugepaged defragmentation.
        };
        "/sys/kernel/mm/transparent_hugepage/shmem_enabled".w = {
          argument = "advise"; # Hugepage allocation policy for the internal shmem mount.
        };
      };

      # ---Cache---
      nix.settings.substituters = [
        "https://nix-gaming.cachix.org"
        "https://nix-community.cachix.org/"
        "https://chaotic-nyx.cachix.org/"
      ];
      nix.settings.trusted-public-keys = [
        "nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "chaotic-nyx.cachix.org-1:HfnXSw4pj95iI/n17rIDy40agHj12WfF+Gqk6SonIT8="
      ];
    };
}
