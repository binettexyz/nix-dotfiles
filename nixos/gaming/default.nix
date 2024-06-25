{ flake, pkgs, lib, config, ... }:

{
  
  imports = [
    #./minecraft-server
    #./leagueoflegends.nix
    #./legendary.nix
    #./lutris.nix
    ./steam.nix
  ];

  options.gaming.enable = pkgs.lib.mkDefaultOption "Gaming config";

  config = lib.mkIf config.gaming.enable {

    environment = {
      systemPackages = with pkgs; [
        piper # GTK frontend for ratbagd mouse config daemon
        jdk # Minecraft Java
        dxvk
        heroic # Heroic luncher for gog and epic games
      ];
    };
  
    /* --Gamemode-- */
    programs.gamemode = {
      enable = true;
      enableRenice = true;
      settings = {
        general = {
          softrealtime = "auto";
          renice = 10;
        };
        custom = {
          start = "${pkgs.libnotify}/bin/notify-send 'GameMode started'";
          end = "${pkgs.libnotify}/bin/notify-send 'GameMode ended'";
        };
      };
    };

      # Flatpak
    services.flatpak.enable = true;
    xdg.portal.enable = true;
    xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-kde ];
  
      # Driver for Xbox One/Series S/Series X controllers
    hardware.xpadneo.enable = true;
  
      # Enable ratbagd (i.e.: piper) for Logitech devices
    services.ratbagd.enable = true;
  
    nix.settings = {
      substituters = [ "https://nix-gaming.cachix.org" ];
      trusted-public-keys = [ "nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4=" ];
    };
  };

}
