{ super, config, lib, pkgs, ... }:

{

  options.gaming.enable = pkgs.lib.mkDefaultOption "gaming Packages";

  modules.device.type = "desktop";

  home.packages = with pkgs; [
    (calibre.override { unrarSupport = true; })
    gimp
    easyeffects
    inkscape
    #FIXME:overlay- open-browser
    pinta
    solaar
#    texlive.combined.scheme-full
    #(unstable.discord.override { withOpenASAR = true; nss = nss_latest; })
    (discord-plugged.override {
      discord-canary = discord-canary.override {
        nss = pkgs.nss_latest;
        withOpenASAR = true;
      };
       plugins = [
        inputs.disc-betterReplies
        inputs.disc-doubleClickVC
        inputs.disc-muteNewGuild
        inputs.disc-popoutFix
        inputs.disc-screenshareCrack
        inputs.disc-unindent
        inputs.disc-silentTyping
      ];
       themes = [
        inputs.disc-gruvbox
      ];
    })
 ];
 config = lib.mkIf config.gaming.enable {
    home.packages = with pkgs; [
        prismlauncher
        grapejuice
        mangohud # afterburner like
        #runescape runelite
        #zeroad
        #yuzu-mainline
        #retroarchFull
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
        #inputs.nix-gaming.packages.${pkgs.system}.osu-stable
        #inputs.nix-gaming.packages.${pkgs.system}.osu-lazer-bin
    ];
  };

}
