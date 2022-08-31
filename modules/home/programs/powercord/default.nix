{ inputs, pkgs, config, lib, ... }:
with lib;

let
  cfg = config.modules.programs.powercord;
in
{
  options.modules.programs.powercord= {
    enable = mkOption {
      description = "Enable powercord overlay";
      type = types.bool;
      default = false;
    };
  };

  config = mkIf (cfg.enable) {
    nixpkgs.overlays = [ inputs.powercord-overlay.overlay ];
    home.packages = with pkgs; [
      (discord-plugged.override {
        discord-canary = discord-canary.override {
          nss = pkgs.nss_latest;
          withOpenASAR = true;
        };

        plugins = [
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
        ];

        themes = [
            # gruvbox
          (builtins.fetchTarball "https://github.com/binettexyz/discord-gruvbox/archive/master.tar.gz")
#          /home/binette/.git/repos/discord-gruvbox
        ];
      })
    ];
  };
}
