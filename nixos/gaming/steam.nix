{ config, flake, pkgs, lib, ... }: {

  imports = [ flake.inputs.nix-gaming.nixosModules.platformOptimizations ];

  options.gaming.steam.enable = pkgs.lib.mkDefaultOption "Steam game launcher.";

  config = lib.mkIf config.gaming.steam.enable {
    hardware.steam-hardware.enable = true;

    programs.steam = {
      enable = true;
      extraCompatPackages = [ pkgs.proton-ge-bin ];
      gamescopeSession.enable = true;
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;
      localNetworkGameTransfers.openFirewall = true;
      platformOptimizations.enable = true;
    };

    environment.systemPackages = with pkgs; [
      # Allow downloading of GE-Proton and other versions
      protonup-qt
    ];
  };

}
