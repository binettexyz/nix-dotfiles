{ flake, pkgs, lib, config, ... }:
with lib;

{
  
  imports = [
    ./jovian-nixos.nix
    ./steam.nix
  ];

  options.modules.gaming.enable = mkOption {
    description = "Gaming config";
    default = false;
  };

  config = lib.mkIf config.modules.gaming.enable {

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

    /* ---Flatpak--- */
    services.flatpak.enable = true;
    xdg.portal.enable = true;
    xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-kde ];
  
    /* ---Drivers--- */
    hardware.xpadneo.enable = true; # Xbox One Controller
    hardware.xone.enable = false; # Xbox One Accessories (USB dongle)
    services.ratbagd.enable = true; # Use with piper

    /* ---Packages--- */
    environment.systemPackages = with pkgs; [
      # Tools
      piper # GTK frontend for ratbagd mouse config daemon
      jdk # Minecraft Java
      dxvk
    ];

    /* ---Games Related Networking--- */
    networking = let
      ports.mindustry = 6567;
      ports.factorio = 6566;
      ports.noita = 5123;
      #ports.minecraft = 0;
    in {
      firewall.allowedTCPPorts = [
        ports.factorio
        ports.mindustry
        #ports.minecraft
        ports.noita
      ];
      firewall.allowedUDPPorts = [
        ports.factorio
        ports.mindustry
        #ports.minecraft
        ports.noita
      ];
    };
  
    /* ---Cache--- */
    nix.settings = {
      substituters = [ "https://nix-gaming.cachix.org" ];
      trusted-public-keys = [ "nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4=" ];
    };
  };

}
