{
  flake,
  pkgs,
  lib,
  config,
  ...
}: {
  imports = [
    ./controllers.nix
    flake.inputs.nix-gaming.nixosModules.platformOptimizations
  ];

  config = lib.mkMerge [
    (lib.mkIf config.modules.gaming.enable {
      # ---Enabling Steam---
      programs.steam = {
        enable = true;
        # https://github.com/NixOS/nixpkgs/issues/162562#issuecomment-1523177264
        package = pkgs.steam.override {
          extraPkgs = pkgs: [
            pkgs.xorg.libXcursor
            pkgs.xorg.libXi
            pkgs.xorg.libXinerama
            pkgs.xorg.libXScrnSaver
            pkgs.libpng
            pkgs.libpulseaudio
            pkgs.libvorbis
            pkgs.stdenv.cc.cc.lib # Provides libstdc++.so.6
            pkgs.libkrb5
            pkgs.keyutils
          ];
        };
        extraPackages = [ pkgs.gamescope pkgs.gamemode pkgs.mangohud ];
        platformOptimizations.enable = true; # Option from nix-gaming.
        protontricks.enable = true;
        remotePlay.openFirewall = true;
        dedicatedServer.openFirewall = true;
      };
      hardware.steam-hardware.enable = true;

      # ---Enabling Gamescope---
      programs.gamescope = let
        # https://github.com/ValveSoftware/gamescope/issues/1711#issuecomment-2779673006
        oldPkgs = import (fetchTarball {
          url = "https://github.com/NixOS/nixpkgs/archive/b9bb118646d853692578bf6204df2ffbc8a499ec.tar.gz";
          sha256 = "0hq5x6x00xwzf75msmfm7i6mfq128nrgv194vx475p5agj02vdjw";
        }) {system = pkgs.system;};
      in {
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
