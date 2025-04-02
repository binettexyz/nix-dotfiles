{ flake, pkgs, lib, config, system, ... }:
with lib;

let
  inherit (config.meta) username;
in {
  
  imports = [
    flake.inputs.jovian-nixos.nixosModules.jovian
    flake.inputs.nix-gaming.nixosModules.platformOptimizations
  ];

  options.modules.gaming = {
    enable = mkOption {
      description = "Gaming config";
      default = false;
    };
    steam.enable = mkOption {
      description = "Enable Steam.";
      default = false;
    };
    device.isSteamdeck = mkOption {
      description = "If device is a steamdeck";
      default = false;
    };
    openPorts = mkOption {
      description = "Open firewall ports for selected games";
      default = false;
    };
  };

  config = mkMerge [
    (mkIf config.modules.gaming.enable {

      /* --Gamemode-- */
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
  

      /* ---Drivers--- */
      hardware.xpadneo.enable = true; # Xbox One Controller
  

      /* ---System Configuration--- */
        # Don't mount /tmp to tmpfs since there's not enough space to build valve kernel.
        # Instead, bind it into home. See "host/seiryu/hardware.nix".
      boot.tmp.useTmpfs = lib.mkForce false;
      boot.plymouth.enable = true; # Enable plymouth.
      boot.kernelParams = [
          # Needed for some **legit** games to run with lutris/wine.
        "clearcpuid=512"
        "splash" # Needed for plymouth.
      ];


      /* ---Performance Tweaks Based On CryoUtilities--- */
        # Determines how aggressively the kernel swaps out memory.
      boot.kernel.sysctl."vm.swappiness" = lib.mkForce 1;
        # Determines how aggressive memory compaction is done in the background.
      boot.kernel.sysctl."vm.compaction_proactiveness" = 0;
        # Determines the number of times that the page lock can be stolen from under a waiter before "fair" behavior kicks in.
      boot.kernel.sysctl."vm.page_lock_unfairness" = 1;
      systemd.tmpfiles.settings."10-gradientos-hugepages.conf" = { # Hugepages
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


      /* ---Cache--- */
      nix.settings.substituters = [ "https://nix-gaming.cachix.org" ];
      nix.settings.trusted-public-keys = 
        [ "nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4=" ];

    })
  

    (mkIf config.modules.gaming.steam.enable {
      programs.steam = {
        enable = true;
          # Option from nix-gaming.
        platformOptimizations.enable = true;
        protontricks.enable = true;
        remotePlay.openFirewall = true;
        dedicatedServer.openFirewall = true;
      };

      hardware.steam-hardware.enable = true;
  
      environment.systemPackages = with pkgs; [
          # Allow downloading of GE-Proton and other versions
        protonup-qt
        gamemode
        mangohud
      ];
    })
  
    /* ---Jovian-NixOS--- */
    (mkIf (config.device.type == "gaming-handheld") {
      jovian.steam = {
        enable = true;
        user = username;
          # Gamescope's desktop mode. Need to force disable "services.xserver.displayManager".
        desktopSession = config.modules.system.desktopEnvironment;
          # Boot straight into gamemode.
        autoStart = true;
      };
    
      jovian.devices.steamdeck = {
        enable = config.modules.gaming.device.isSteamdeck;
        autoUpdate = config.modules.gaming.device.isSteamdeck; # Auto update firmware/bios. Can be manually be done if disabled with the tools in systemPackages bellow.
      };
    
      jovian.decky-loader = { # Requires enabling CEF remote debugging in dev mode settings.
        enable = true;
        user = username;
      };
    
        # Steamdeck firmwate updater
      environment.systemPackages = with pkgs; [ steamdeck-firmware ];
    })
  
    /* ---Games Related Networking--- */
    (mkIf config.modules.gaming.openPorts {
      networking = let
        ports.mindustry = 6567;
        ports.factorio = 6566;
        ports.noita = 5123;
        ports.minecraft = 25565;
      in {
        firewall.allowedTCPPorts = [
          ports.factorio
          ports.mindustry
          ports.minecraft
          ports.noita
        ];
        firewall.allowedUDPPorts = [
          ports.factorio
          ports.mindustry
          ports.minecraft
          ports.noita
        ];
      };
    })
  ];

}
