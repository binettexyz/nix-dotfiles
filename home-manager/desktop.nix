{ super, config, lib, pkgs, ... }:
with lib;
{

  imports = [
    ./minimal.nix
    ./lf
    ./mpv
    ./newsboat.nix
    ./pc.nix
  ];
  options.gaming.enable = pkgs.lib.mkDefaultOption "gaming Packages";

  config = (mkMerge [
    ({
      modules.device.type = "desktop";

      home.packages = with pkgs; [
        (calibre.override { unrarSupport = true; })
        easyeffects
        gimp
        inkscape
        mcrcon
        #FIXME:overlay- open-browser
        pinta
        solaar
        tidal-hifi
    #    texlive.combined.scheme-full
        (unstable.discord.override { withOpenASAR = true; nss = nss_latest; })
      ];
      })
      (mkIf config.gaming.enable {
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
        ];
      })
    
      (mkIf (config.modules.devices.type == "lsptop") {
      })
        #inputs.nix-gaming.packages.${pkgs.system}.osu-stable
        #inputs.nix-gaming.packages.${pkgs.system}.osu-lazer-bin
  ]);

  }

