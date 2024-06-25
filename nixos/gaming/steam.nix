{ config, flake, pkgs, lib, ... }: {

  imports = [ flake.inputs.nix-gaming.nixosModules.platformOptimizations ];

  options.gaming.steam.enable = pkgs.lib.mkDefaultOption "Steam game launcher.";

  config = lib.mkIf config.gaming.steam.enable {
    hardware.steam-hardware.enable = true;
    #unfreePackages = [ "steam" "steam-original" "steamcmd" "steam-run" ];

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

#    home-manager.sharedModules =
#      let
#        version = "GE-Proton7-49";
#        proton-ge = fetchTarball {
#          url = "https://github.com/GloriousEggroll/proton-ge-custom/releases/download/${version}/${version}.tar.gz";
#          sha256 = "sha256:1wwxh0yk78wprfi1h9n7jf072699vj631dl928n10d61p3r90x82";
#        };
#      in [
#        ({ config, lib, pkgs, ... }: {
#          home.activation.proton-ge-custom = ''
#            if [ ! -d "$HOME/.steam/root/compatibilitytools.d/${version}" ]; then
#              cp -rsv ${proton-ge} "$HOME/.steam/root/compatibilitytools.d/${version}"
#            fi
#          '';
#        })
#      ];

  };

}
