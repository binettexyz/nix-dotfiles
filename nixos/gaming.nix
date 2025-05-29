{
  deviceType,
  flake,
  pkgs,
  lib,
  config,
  ...
}: let
  inherit (config.meta) username;
in {
  imports = [
    flake.inputs.jovian-nixos.nixosModules.jovian
    flake.inputs.nix-gaming.nixosModules.platformOptimizations
  ];

  options.modules.gaming = {
    enable = lib.mkOption {
      description = "Gaming config";
      default = false;
    };
    steam.enable = lib.mkOption {
      description = "Enable Steam.";
      default = false;
    };
    device.isSteamdeck = lib.mkOption {
      description = "If device is a steamdeck";
      default = false;
    };
    valveControllersRules = lib.mkOption {
      description = "Add controllers rules from valve";
      default = false;
    };
    openPorts = lib.mkOption {
      description = "Open firewall ports for selected games";
      default = false;
    };
  };

  config = lib.mkMerge [
    (lib.mkIf config.modules.gaming.enable {
      # --Gamemode--
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

      # ---Services---
      services.sunshine = {
        enable = true;
        autoStart = false;
        openFirewall = false;
        capSysAdmin = true;
        applications = {
          env = {PATH = "$(PATH):$(HOME)/.local/bin";};
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
        enable = true;
        unitConfig = {
          Description = "MoonDeckBuddy";
          After = ["graphical-session.target"];
        };
        serviceConfig = {
          ExecStart = "${pkgs.moondeck-buddy}/bin/MoonDeckBuddy";
          Restart = "on-failure";
        };
        wantedBy = ["graphical-session.target"];
      };

      # ---Drivers---
      hardware.xpadneo.enable = true; # Xbox One Controller

      # ---Udev Rules---
      #services.udev.packages = [ pkgs.game-devices-udev-rules ];
      # Disable DualSense controller touchpad being recognized as a trackpad
      services.udev.extraRules = ''
        ACTION=="add|change", KERNEL=="event[0-9]*", ATTRS{name}=="*Wireless Controller Touchpad", ENV{LIBINPUT_IGNORE_DEVICE}="1"
      '';

      # ---System Configuration---
      # Don't mount /tmp to tmpfs since there's not enough space to build valve kernel.
      # Instead, bind it into home. See "host/seiryu/hardware.nix".
      boot.tmp.useTmpfs = lib.mkForce false;
      boot.plymouth.enable = true; # Enable plymouth.
      boot.kernelParams = [
        # Needed for some **legit** games to run with lutris/wine.
        "clearcpuid=512"
        "splash" # Needed for plymouth.
      ];

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
      nix.settings.substituters = ["https://nix-gaming.cachix.org"];
      nix.settings.trusted-public-keys = [
        "nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4="
      ];
    })

    (lib.mkIf config.modules.gaming.steam.enable {
      programs.steam = {
        enable = true;
        # Option from nix-gaming.
        platformOptimizations.enable = true;
        protontricks.enable = true;
        remotePlay.openFirewall = true;
        dedicatedServer.openFirewall = true;
        gamescopeSession.enable = true;
      };
      programs.gamescope = {
        enable = true;
        package = pkgs.stable.gamescope;
        capSysNice = false;
        args = [
          "--rt"
          "--force-grab-cursor"
          "--expose-wayland"
          "--nested-unfocused-refresh 30"
        ];
      };

      hardware.steam-hardware.enable = true;

      environment.systemPackages = [
        # Allow downloading of GE-Proton and other versions
        pkgs.protonup-qt
        pkgs.mangohud
      ];
    })

    # ---Jovian-NixOS---
    (lib.mkIf (deviceType == "handheld") {
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

      jovian.decky-loader = {
        # Requires enabling CEF remote debugging in dev mode settings.
        enable = true;
        user = username;
      };

      # Steamdeck firmwate updater
      environment.systemPackages = [pkgs.steamdeck-firmware];
    })

    (lib.mkIf config.modules.gaming.valveControllersRules {
      services.udev.extraRules = ''
        # Valve USB devices
        SUBSYSTEM=="usb", ATTRS{idVendor}=="28de", MODE="0660", TAG+="uaccess"
        # Steam Controller udev write access
        KERNEL=="uinput", SUBSYSTEM=="misc", TAG+="uaccess", OPTIONS+="static_node=uinput"
        # Valve HID devices over USB hidraw
        KERNEL=="hidraw*", ATTRS{idVendor}=="28de", MODE="0660", TAG+="uaccess"
        # Valve HID devices over bluetooth hidraw
        KERNEL=="hidraw*", KERNELS=="*28DE:*", MODE="0660", TAG+="uaccess"
        # DualShock 4 over bluetooth hidraw
        KERNEL=="hidraw*", KERNELS=="*054C:05C4*", MODE="0660", TAG+="uaccess"
        # DualShock 4 over USB hidraw
        KERNEL=="hidraw*", ATTRS{idVendor}=="054c", ATTRS{idProduct}=="05c4", MODE="0660", TAG+="uaccess"
        # DualShock 4 wireless adapter over USB hidraw
        KERNEL=="hidraw*", ATTRS{idVendor}=="054c", ATTRS{idProduct}=="0ba0", MODE="0660", TAG+="uaccess"
        # DualShock 4 Slim over USB hidraw
        KERNEL=="hidraw*", ATTRS{idVendor}=="054c", ATTRS{idProduct}=="09cc", MODE="0660", TAG+="uaccess"
        # PS5 DualSense controller over USB hidraw
        KERNEL=="hidraw*", ATTRS{idVendor}=="054c", ATTRS{idProduct}=="0ce6", MODE="0660", TAG+="uaccess"
        # PS5 DualSense controller over bluetooth hidraw
        KERNEL=="hidraw*", KERNELS=="*054C:0CE6*", MODE="0660", TAG+="uaccess"
        # Nintendo Switch Pro Controller over USB hidraw
        KERNEL=="hidraw*", ATTRS{idVendor}=="057e", ATTRS{idProduct}=="2009", MODE="0660", TAG+="uaccess"
        # Nintendo Switch Pro Controller over bluetooth hidraw
        KERNEL=="hidraw*", KERNELS=="*057E:2009*", MODE="0660", TAG+="uaccess"
        # DualShock 3 over USB hidraw
        KERNEL=="hidraw*", ATTRS{idVendor}=="054c", ATTRS{idProduct}=="0268", MODE="0660", TAG+="uaccess"
        # DualShock 3 over bluetooth hidraw
        KERNEL=="hidraw*", KERNELS=="*054C:0268*", MODE="0660", TAG+="uaccess"
      '';
    })

    # ---Games Related Networking---
    (lib.mkIf config.modules.gaming.openPorts {
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
