{
  flake,
  pkgs,
  lib,
  config,
  ...
}:
{
  imports = [
    ./controllers.nix
    flake.inputs.nix-gaming.nixosModules.platformOptimizations
    flake.inputs.chaotic.nixosModules.default
  ];

  options.modules.gaming = {
    enable = lib.mkEnableOption "Enable Gaming";
    device.isSteamdeck = lib.mkOption {
      description = "If device is a steamdeck";
      default = false;
    };
    services.sunshine.enable = lib.mkEnableOption "Enable Sunshine";
  };

  config = lib.mkMerge [
    (lib.mkIf config.modules.gaming.enable {
      boot.kernelPackages = lib.mkForce pkgs.linuxPackages_cachyos;

      # ---Enabling Steam---
      programs.steam = {
        enable = true;
        package = pkgs.steam;
        extraPackages = [
          pkgs.gamescope
          pkgs.gamemode
          pkgs.mangohud
        ];
        platformOptimizations.enable = true; # Option from nix-gaming.
        protontricks.enable = true;
        remotePlay.openFirewall = true;
        dedicatedServer.openFirewall = true;
      };
      hardware.steam-hardware.enable = true;

      # ---Enabling Gamescope---
      programs.gamescope = {
        enable = true;
        package = pkgs.gamescope;
        capSysNice = false;
        args = [
          "--force-grab-cursor"
          "--backend sdl"
          "--nested-unfocused-refresh 30"
        ];
      };

      # ---Enabling Gamemode---
      programs.gamemode = {
        enable = true;
        enableRenice = true;
        settings.general = {
          softrealtime = "auto";
          renice = 10;
        };
        settings.custom = {
          start = "${pkgs.libnotify}/bin/notify-send 'GameMode started'";
          end = "${pkgs.libnotify}/bin/notify-send 'GameMode ended'";
        };
      };

      # ---Packages---
      environment.systemPackages = [
        # Allow downloading of GE-Proton and other versions
        pkgs.protonup-qt
        pkgs.mangohud
      ];

      # ---Services---
      services.sunshine = {
        enable = config.modules.gaming.services.sunshine.enable;
        autoStart = false;
        openFirewall = false;
        capSysAdmin = true;
        applications = {
          env = {
            PATH = "$(PATH):$(HOME)/.local/bin";
          };
          apps = [
            {
              name = "Desktop";
              image-path = "desktop.png";
            }
            {
              name = "Steam Big Picture";
              output = "steam.txt";
              detached = [
                "${pkgs.util-linux}/bin/setsid ${pkgs.steam}/bin/steam steam://open/bigpicture"
              ];
              image-path = "steam.png";
            }
            {
              name = "MoonDeckStream";
              command = "${pkgs.moondeck-buddy}/bin/MoonDeckStream";
              image-path = "steam.png";
              auto-detach = "false";
              wait-all = "false";
            }
          ];
        };
      };
      systemd.user.services.moondeck-buddy = {
        enable = config.modules.gaming.device.isSteamdeck;
        unitConfig = {
          Description = "MoonDeckBuddy";
          After = [ "graphical-session.target" ];
        };
        serviceConfig = {
          ExecStart = "${pkgs.moondeck-buddy}/bin/MoonDeckBuddy";
          Restart = "on-failure";
        };
        wantedBy = [ "graphical-session.target" ];
      };

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
    })
  ];
}
