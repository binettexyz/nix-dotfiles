{ config, pkgs, lib, ... }:

let
  powercord-overlay = import (builtins.fetchTarball "https://github.com/LavaDesu/powercord-overlay/archive/master.tar.gz");
in
  
{

  services.sonarr.enable = true;

  nixpkgs.overlays = [ powercord-overlay.overlay ];


  environment.systemPackages = with pkgs; [
    #(unstable.discord.override { withOpenASAR = true; nss = nss_latest; })
    flameshot
    unstable.tidal-hifi

    (discord-plugged.override {
      discord-canary = discord-canary.override {
        nss = pkgs.nss_latest;
        withOpenASAR = true;
      };

      plugins = [
          # BetterMediaPlayer
        (builtins.fetchTarball "https://github.com/doggybootsy/BetterMediaPlayer/archive/master.tar.gz")
          # better status indicators
        (builtins.fetchTarball "https://github.com/griefmodz/better-status-indicators/archive/master.tar.gz")
          # better replies
        (builtins.fetchTarball "https://github.com/cyyynthia/better-replies/archive/master.tar.gz")
          # better settings
        (builtins.fetchTarball "https://github.com/mr-miner1/better-settings/archive/master.tar.gz")
          # show all activities
        (builtins.fetchTarball "https://github.com/Juby210/show-all-activities/archive/master.tar.gz")
          # double click vc
        (builtins.fetchTarball "https://github.com/discord-modifications/double-click-vc/archive/master.tar.gz")
          # mute new guild
        (builtins.fetchTarball "https://github.com/RazerMoon/muteNewGuild/archive/master.tar.gz")
          # popout fix
        (builtins.fetchTarball "https://github.com/Nexure/PowerCord-Popout-Fix/archive/master.tar.gz")
          # screenshare crack
        (builtins.fetchTarball "https://github.com/discord-modifications/screenshare-crack/archive/master.tar.gz")
          # Unindent
        (builtins.fetchTarball "https://github.com/VenPlugs/Unindent/archive/master.tar.gz")
          # vpc-shiki
        (builtins.fetchTarball "https://github.com/Vap0r1ze/vpc-shiki/archive/master.tar.gz")
          # silent typing
        (builtins.fetchTarball "https://github.com/svby/powercord-silenttyping/archive/master.tar.gz")
          # image-tools
        (builtins.fetchTarball "https://github.com/powerfart-plugins/image-tools/archive/master.tar.gz")
      ];

      themes = [
          # gruvbox
        (builtins.fetchTarball "https://github.com/CircuitRCAY/Duvbox/archive/master.tar.gz")
      ];
    })
  ];
}


