{ config, flake, pkgs, lib, ... }:
with lib;

{

  imports = [ flake.inputs.nix-gaming.nixosModules.platformOptimizations ];

  options.modules.gaming.steam.enable = mkOption {
    description = "Steam game launcher.";
    default = false;
  };

  config = lib.mkIf config.modules.gaming.steam.enable {
    hardware.steam-hardware.enable = true;

    programs.steam = {
      enable = true;
        # Runs steam with https://github.com/Supreeeme/extest
        # Without this, steam input on wayland sessions doesn't draw a visible cursor.
      extest.enable = true;
        # Modules from nix-gaming.
      platformOptimizations.enable = true;
      protontricks.enable = true;
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;
      extraCompatPackages = [ pkgs.proton-ge-bin ];
      extraPackages = with pkgs; [ gamescope mangohud ];
      package = pkgs.steam.override {
        extraEnv.MANGOHUD = true;
      };
    };

    environment.systemPackages = with pkgs; [
      # Allow downloading of GE-Proton and other versions
      protonup-qt
    ];
  };

}
