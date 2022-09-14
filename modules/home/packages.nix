{ pkgs, lib, config, inputs, ... }:
with lib;

let 
  cfg = config.modules.packages;
#    screen = pkgs.writeShellScriptBin "screen" ''${builtins.readFile ./screen}'';
#    maintenance = pkgs.writeShellScriptBin "maintenance" ''${builtins.readFile ./maintenance}'';

in {
  options.modules.packages = {
    enable = mkOption {
      description = "Enable packages";
      type = types.bool;
      default = true;
    };
    gaming.enable = mkOption {
      description = "Enable gaming packages";
      type = types.bool;
      default = false;
    };
  };

  config = mkIf (cfg.enable) (mkMerge [
    ({
      home.packages = with pkgs; [
          # system
        xorg.xinit
        xorg.xev
        xorg.xmodmap
        xdotool
        maim
        slop
        xclip
        hsetroot
        udiskie
        unclutter-xfixes
        xbanish # Hides the mouse when using the keyboard
        dunst
        xcape
          # media
        nsxiv
        playerctl
        jellyfin-mpv-shim
        jellyfin-media-player
        trackma
          # text
        #emacs
        zathura
        mupdf
        #texlive.combined.scheme-full
          # rss
        newsboat
          # audio mixer
        pulsemixer
        pamixer
        pamixer
          # transmission
        tremc

          # logitech device manager
#        solaar
    
#          # kindle
#       calibre
#       calibre-web
          # emails
#        mutt-wizard
#        neomutt
#        isync
#        msmtp
#        lynx
#        notmuch
#        abook
#        urlview
#        mpop
          #rcon
#       mcrcon
      ];
    })
    (mkIf cfg.gaming.enable {
      home.packages = with pkgs; [
        polymc # minecraft client
        mangohud # afterburner like
        runescape runelite
        zeroad
        yuzu-mainline
          # retroarch with specific cores
        (retroarch.override {
          cores = [
            libretro.mgba
            libretro.snes9x
            libretro.mesen
            libretro.parallel-n64
            libretro.dolphin
            libretro.pcsx2
            libretro.ppsspp
          ];
        })
      ];
    })
  ]);

}
