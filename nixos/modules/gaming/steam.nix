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
      extraCompatPackages = [ pkgs.proton-ge-bin ];
#      gamescopeSession.enable = true;
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;
#      localNetworkGameTransfers.openFirewall = true;
      platformOptimizations.enable = true;
    };

    environment.systemPackages = with pkgs; [
      # Allow downloading of GE-Proton and other versions
      protonup-qt
    ];
  };

}
