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
      boot.plymouth.enable = true; # Enable plymouth.
      boot.kernelParams = [
          # Needed for some **legit** games to run with lutris/wine.
        "clearcpuid=512"
        "splash" # Needed for plymouth.
      ];
   
      /* ---Cache--- */
      nix.settings = {
        substituters = [ "https://nix-gaming.cachix.org" ];
        trusted-public-keys = [ "nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4=" ];
      };
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
