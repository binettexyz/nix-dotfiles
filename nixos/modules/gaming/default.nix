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

    /* ---Drivers--- */
    hardware.xpadneo.enable = true; # Xbox One Controller
    hardware.xone.enable = false; # Xbox One Accessories (USB dongle)

    /* ---Packages--- */
    environment.systemPackages = with pkgs; [
      jdk # Minecraft Java
      dxvk
    ];

    /* ---Games Related Networking--- */
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
  
    /* ---Cache--- */
    nix.settings = {
      substituters = [ "https://nix-gaming.cachix.org" ];
      trusted-public-keys = [ "nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4=" ];
    };
  };

}
