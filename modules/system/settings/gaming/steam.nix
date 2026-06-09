{ inputs, ... }:
{
  flake.nixosModules.steam =
    { pkgs, ... }:
    {
      imports = [ inputs.nix-gaming.nixosModules.platformOptimizations ];
      # ---Enabling Steam---
      programs.steam = {
        enable = true;
        extraPackages = [
          pkgs.gamescope
          pkgs.gamemode
          pkgs.mangohud
        ];
        gamescopeSession.enable = true;
        gamescopeSession.env = {
          #DXVK_HDR = "1"; # HDR not workin
        };
        gamescopeSession.args = [
          "-w 2560"
          "-W 3440"
          "-h 1440"
          "-H 2560"
          "-r 120"
          "--steam"
          "-F fsr"
          "--adaptive-sync"
          "--hdr-enabled"
          "--prefer-output 'HDMI-A-1'"
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

    };
}
