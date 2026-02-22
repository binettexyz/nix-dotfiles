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

    };
}
